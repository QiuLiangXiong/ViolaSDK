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

@property (nullable, nonatomic, strong) NSMutableArray * uiTasks;

@end

@implementation VAComponentController

- (instancetype)init
{
    self = [super init];
    if (self) {
       _allComponentsDic = [NSMapTable strongToWeakObjectsMapTable];
       _uiTasks = [NSMutableArray new];//ui任务数组
    }
    return self;
}

#pragma mark - public


- (void)createBody:(NSDictionary *)body{
    VAAssertComponentThread();
    VAAssertReturn([body isKindOfClass:[NSDictionary class]], @"body type error");
    
    VAAssertReturn(!_rootComponent, @"can't be call twice in the same instance");//同一个实例不能被调用两次
    
    _rootComponent = [self _createComponentWithEle:@{@"ref":VA_ROOT_REF,@"type":@"div",@"style":@{}}];
    [self rootViewFrameDidChange:self.vaInstance.instanceFrame];
    kBlockWeakSelf;
    [self _addUITask:^{
        if(weakSelf){
            kBlockStrongSelf;
            [strongSelf.vaInstance.rootView addSubview:strongSelf.rootComponent.view];
        }
    }];
    //添加真元素
    [self addComponent:body toSupercomponent:_rootComponent.ref atIndex:0];
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
}

- (void)unload{
    VAAssertComponentThread();
}


- (void)addComponent:(NSDictionary *)componentData toSupercomponent:(NSString *)parentRef atIndex:(NSInteger)index{
    VAAssertComponentThread();
    VAAssertReturn(componentData && parentRef, @"can't be nil");
    
    VAComponent *superComponent = [_allComponentsDic objectForKey:parentRef];
    VAAssertReturn(superComponent, @"dont't exisxt ref");
    [self _addComponent:componentData toSupercomponent:superComponent atIndex:index];
    [self _syncLayoutAndUITasks];
}

#pragma mark - private

- (VAComponent *)_createComponentWithEle:(NSDictionary *)ele{
    NSString *ref = ele[@"ref"];
    NSString *type = ele[@"type"];
    NSDictionary *styles = ele[@"style"];
    NSDictionary *attributes = ele[@"attr"];
    NSArray *events = ele[@"event"];
    
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
    if (!parentComponent.supercomponent) {
        index = 0;
    } else {
        index = (index == -1 ? parentComponent->_subcomponents.count : index);
        if(index > parentComponent->_subcomponents.count){
            index =  parentComponent->_subcomponents.count;
        }
    }
    
    [parentComponent _insertSubcomponent:component atIndex:index];

    [self _addUITask:^{
        [parentComponent insertSubview:component atIndex:index];
    }];

    NSArray *children = [componentData valueForKey:@"children"];

    for(NSDictionary *componentData in children){
        [self _addComponent:componentData toSupercomponent:component atIndex:-1];
    }

}

- (void)_addUITask:(dispatch_block_t)block
{
    [_uiTasks addObject:block];
}

- (void)_syncLayoutAndUITasks{
    [self _layout];
    
    if(_uiTasks.count > 0){
        NSArray<dispatch_block_t> *blocks = _uiTasks;
        _uiTasks = [NSMutableArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            for(dispatch_block_t block in blocks) {
                block();
            }
        });
    }
}

- (void)_layout
{
    BOOL needsLayout = NO;
    
    NSEnumerator *enumerator = [_allComponentsDic objectEnumerator];
    VAComponent *component;
    while ((component = [enumerator nextObject])) {
        if ([component isNeedsLayout]) {
            needsLayout = YES;
            break;
        }
    }
    if (!needsLayout) {
        return;
    }
    css_node_t * rootNode = _rootComponent->_cssNode;
    layoutNode(rootNode, rootNode->style.dimensions[CSS_WIDTH], rootNode->style.dimensions[CSS_HEIGHT], CSS_DIRECTION_INHERIT);
    
   
    
    NSMutableSet<VAComponent *> *dirtyComponents = [NSMutableSet set];
    [_rootComponent _calculateComponentFrameWithDirtyComponents:dirtyComponents];

    
    for (VAComponent *dirtyComponent in dirtyComponents) {
        [self _addUITask:^{
            [dirtyComponent layoutDidEnd];
        }];
    }
}

@end
