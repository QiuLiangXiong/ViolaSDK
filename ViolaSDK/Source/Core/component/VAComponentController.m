//
//  VAComponentController.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAComponentController.h"
#import "VADefine.h"
#import "VAThreadManager.h"
#import "VADivComponent.h"
#import "VARegisterManager.h"
#import "ViolaInstance.h"
#import "VAComponent+private.h"
#import "VARootView.h"




@interface VAComponentController()

@property (nullable, nonatomic, strong ,readwrite) VAComponent * rootComponent;

@property (nullable, nonatomic, strong) NSMapTable<NSString *, VAComponent *> *allComponentsDic;

@property (nullable, nonatomic, strong) NSMutableArray * mainQueueTasks;

@property (nonatomic, assign) BOOL __setNeedSyncLayoutAndMainQuequeTasks;

@end

@implementation VAComponentController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mainQueueTasks = [NSMutableArray new];//主线程任务
        _allComponentsDic = [NSMapTable strongToWeakObjectsMapTable];//
        _isEnable = true;
    }
    return self;
}

#pragma mark - public


- (void)createBody:(NSDictionary *)body{
    VAAssertComponentThread();
    VAAssertReturn([body isKindOfClass:[NSDictionary class]], @"body type error");
    
//    VAAssertReturn(!_rootComponent, @"can't be call twice in the same instance");//同一个实例不能被调用两次
    
    _rootComponent = [self _createComponentWithEle:@{@"ref":VA_ROOT_REF,@"type":@"div",@"style":@{}}];
    _rootComponent.isRootComponent = YES;
    [self rootViewFrameDidChange:self.vaInstance.instanceFrame];
    kBlockWeakSelf;
    [self _addTaskToMainQueue:^{
        if(weakSelf){
            kBlockStrongSelf;
            [strongSelf.vaInstance.rootView addSubview:strongSelf.rootComponent.view];
        }
    }];
    //添加真元素
    [self addComponent:body toSupercomponent:_rootComponent.ref atIndex:0];
    

    dispatch_async([VAThreadManager getComponentQueue], ^{

        
        
       [VAThreadManager violaIntanceRenderFinish];
    });
    [VAThreadManager performOnComponentThreadWithBlock:^{
        weakSelf.isBodyLayoutFinish = true;
    } afterDelay:0.5];

    

    
}

- (VAComponent *)componentWithRef:(NSString *)ref{
    VAAssertComponentThread();
    if([ref isKindOfClass:[NSString class]]){
      return [_allComponentsDic objectForKey:ref];
    }
    return nil;
}

- (void)rootViewFrameDidChange:(CGRect)frame{
    VAAssertComponentThread();
    NSString * width = [NSString stringWithFormat:@"%ddp",(int)frame.size.width];
    NSString * height = [NSString stringWithFormat:@"%ddp",(int)frame.size.height];
    [_rootComponent _updateLayoutWithStyles:@{@"width":width,@"height":height}];
    [_rootComponent setNeedsLayout];
    [self _layoutComponnets];
}

- (void)unload{
    VAAssertComponentThread();
}


- (void)addComponent:(NSDictionary *)componentData toSupercomponent:(NSString *)parentRef atIndex:(NSInteger)index{
    VAAssertComponentThread();
    VAAssertReturn(componentData && parentRef, @"can't be nil");
    
     BOOL animated = [VAConvertUtl convertToBOOL:componentData[@"animated"]];
    if (animated) {
        self.mainQueueSyncWithAnimated = animated;
    }
    VAComponent *superComponent = [_allComponentsDic objectForKey:parentRef];
    VAAssertReturn(superComponent, @"dont't exisxt ref");
    [self _addComponent:componentData toSupercomponent:superComponent atIndex:index];
    [self _syncComponentsLayoutAndMainQueueTasks];
}

- (void)updateComponentWithRef:(NSString *)ref componentData:(NSDictionary *)componentData{
    if(!ref){
        ref = [VAConvertUtl convertToString:componentData[@"ref"]] ;
    }
    NSDictionary *styles = componentData[@"style"];
    NSDictionary *attributes = componentData[@"attr"];
    NSArray *events = componentData[@"events"];
    
    
    VAAssertReturn(ref, @"can't be nil");
    VAComponent *component = [_allComponentsDic objectForKey:ref];
    __weak typeof(&*component) weakComponent = component;
    if(component.animatedEnable){
        self.mainQueueSyncWithAnimated = component.animatedEnable;
    }
    VAAssertReturn(component, @"not found");
    if ([attributes isKindOfClass:[NSDictionary class]] && attributes.count) {
        [component _updateAttributesOnComponentThread:attributes];
        [self _addTaskToMainQueue:^{
            [weakComponent _updateAttributesOnMainThread:attributes];
        }];
    }
    
    if ([styles isKindOfClass:[NSDictionary class]] && styles.count) {
        [component _updateStylesOnComponentThread:styles];
        if(component.animatedEnable){
            self.mainQueueSyncWithAnimated = component.animatedEnable;
        }
        [self _addTaskToMainQueue:^{
            [weakComponent _updateStylesOnMainThread:styles];
        }] ;
    }
  
    if ([events isKindOfClass:[NSArray class]] && events.count) {
        [component _updateEventsOnComponentThread:events];
        [self _addTaskToMainQueue:^{
            [weakComponent _updateEventsOnMainThread:events];
        }];
    }
    [component updateComponentOnComponentThreadWithAttributes:attributes styles:styles events:events];
    [self _addTaskToMainQueue:^{
        [weakComponent updateComponentOnMainThreadWithAttributes:attributes styles:styles events:events];
    }];
}


- (void)removeComponent:(NSString *)ref{
    VAAssertComponentThread();
    VAAssertReturn(ref, @"nil");
    VAComponent *component = [_allComponentsDic objectForKey:ref];
    VAAssertReturn(component, @"not found");
    if(component.animatedEnable){
        self.mainQueueSyncWithAnimated = true;
    }
    [component _removeFromSupercomponent];
    
    [_allComponentsDic removeObjectForKey:ref];
    [self _addTaskToMainQueue:^{
        [component removeFromSuperview];
    }];
}


- (void)moveComponentWithRef:(NSString *)ref toParent:(NSString *)parentRef atIndex:(NSInteger)index{
    VAAssertComponentThread();
    VAAssertReturn(ref && parentRef, @"nil");
    VAComponent *component = [_allComponentsDic objectForKey:ref];
    VAComponent * parentComponent = [_allComponentsDic objectForKey:parentRef];
    VAAssertReturn(component && parentComponent, @"not found");
    if (component.supercomponent == parentComponent && [parentComponent.subcomponents indexOfObject:component] < index) {
        index--;
    }
    [component _moveToSupercomponent:parentComponent atIndex:index];
    [self _addTaskToMainQueue:^{
        [component moveToSuperview:parentComponent atIndex:index];
    }];
}


- (void)addTaskToMainQueueOnComponentThead:(dispatch_block_t)block{
    VAAssertComponentThread();
    [self addTaskToMainQueueOnComponentThead:block withAnimated:false];
}

- (void)addTaskToMainQueueOnComponentThead:(dispatch_block_t)block withAnimated:(BOOL)animated{
    if (!_mainQueueSyncWithAnimated) {
       _mainQueueSyncWithAnimated = animated;
    }
     [self _addTaskToMainQueue:block];
}

- (void)setNeedsLayout{
    [self _setNeedSyncLayoutAndMainQuequeTasks];
}

#pragma mark - private

- (VAComponent *)_createComponentWithEle:(NSDictionary *)ele{
    NSString *ref = [VAConvertUtl convertToString:ele[@"ref"]] ;
    NSString *type = [VAConvertUtl convertToString:ele[@"type"]];
    NSDictionary *styles = ele[@"style"];
    NSDictionary *attributes = ele[@"attr"];
    NSArray *events = ele[@"events"];
    
    Class componentClass = [VARegisterManager classWithComponentType:type];
    VAAssert(componentClass, @"not register it");
    VAComponent *component = [[componentClass alloc] initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:self.vaInstance];
    VAAssert(component , @"create failed");
    [_allComponentsDic setObject:component forKey:component.ref];
    return component;
}


- (void)_addComponent:(NSDictionary *)componentData toSupercomponent:(VAComponent *)parentComponent atIndex:(NSInteger)index{
    VAAssertReturn(componentData && parentComponent, @"can't be nil");
    VAComponent *component = [self _createComponentWithEle:componentData];
    
    if(parentComponent == _rootComponent){
        [component _updateLayoutWithStyles:@{@"flex":@(1)
                                             }];
    }
    
    if (!parentComponent.supercomponent) {
        index = 0;
    } else {
        index = (index == -1 ? parentComponent->_subcomponents.count : index);
        if(index > parentComponent->_subcomponents.count){
            index =  parentComponent->_subcomponents.count;
        }
    }
    
    [parentComponent _insertSubcomponent:component atIndex:index];

    if(component.animatedEnable){
        self.mainQueueSyncWithAnimated = true;
    }
    [self _addTaskToMainQueue:^{
        [parentComponent insertSubview:component atIndex:index];
    }];

    NSArray *children = [componentData valueForKey:@"children"];

    for(NSDictionary *componentData in children){
        [self _addComponent:componentData toSupercomponent:component atIndex:-1];
    }

}


- (void)_layoutComponnets{
    if ([self _isNeedUpdateLayout]) {
        css_node_t * rootNode = _rootComponent->_cssNode;
        layoutNode(rootNode, rootNode->style.dimensions[CSS_WIDTH], rootNode->style.dimensions[CSS_HEIGHT], CSS_DIRECTION_INHERIT);
        NSMutableArray * dirtyComponents = [NSMutableArray new];
        [_rootComponent _syncCSSNodeLayoutWithDirtyComponents:dirtyComponents];
        [self _notifyLayoutDidEndWithComponents:dirtyComponents];
    }
}

- (BOOL)_isNeedUpdateLayout{
    BOOL res = NO;
    NSEnumerator *enumerator = [_allComponentsDic objectEnumerator];
    VAComponent *component;
    while ((component = [enumerator nextObject])) {
        if ([component isNeedsLayout]) {
            res = YES;
            break;
        }
    }
    return res;
}

- (void)_notifyLayoutDidEndWithComponents:(NSMutableArray *)components{
    for (VAComponent *component in components) {
        [self _addTaskToMainQueue:^{
            [component layoutDidEnd];
        }];
    }
}


- (void)_notifyAllComponetBeforeMainQueueAnimation{
    VAAssertMainThread();
    NSEnumerator *enumerator = [_allComponentsDic objectEnumerator];
    VAComponent *component;
    while ((component = [enumerator nextObject])) {
        [component mainQueueWillSyncBeforeAnimation];
    }
}


- (void)_addTaskToMainQueue:(dispatch_block_t)block{
    if (!_mainQueueTasks) {
        _mainQueueTasks = [NSMutableArray new];
    }
    [_mainQueueTasks addObject:block];
    [self _setNeedSyncLayoutAndMainQuequeTasks];
}

//同步布局和主线程队列任务
- (void)_syncComponentsLayoutAndMainQueueTasks{
    [self _layoutComponnets];
    [self _syncMainQueueTask];
}

- (void)_syncMainQueueTask{
    if(_mainQueueTasks.count > 0){
        NSArray<dispatch_block_t> *blocks = _mainQueueTasks;
        _mainQueueTasks = [NSMutableArray array];
        BOOL animated = _mainQueueSyncWithAnimated;
        _mainQueueSyncWithAnimated = false;
        
        if(!self.isBodyLayoutFinish){
            animated = false;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (animated ) {
                [self _notifyAllComponetBeforeMainQueueAnimation];
            
                
                
                [UIView animateWithDuration:0.2 animations:^{
                    for(dispatch_block_t block in blocks) {
                        block();
                    }
                }];
            }else {
                for(dispatch_block_t block in blocks) {
                    block();
                }
            }
        });
    }
}


-(void)_setNeedSyncLayoutAndMainQuequeTasks{
    if (!___setNeedSyncLayoutAndMainQuequeTasks) {
         ___setNeedSyncLayoutAndMainQuequeTasks = true;
        dispatch_queue_t queue = [VAThreadManager getComponentQueue];
        kBlockWeakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0) * NSEC_PER_SEC)),queue, ^{
              VALogDebug(@"%s___syncComponentsLayoutAndMainQueueTasks",__func__);
              weakSelf.__setNeedSyncLayoutAndMainQuequeTasks = false;
              [weakSelf _syncComponentsLayoutAndMainQueueTasks];
        });
    }

}

#pragma mark - getter


- (void)dealloc{
    
}

@end
