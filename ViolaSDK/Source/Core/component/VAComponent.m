//
//  VAComponent.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAComponent.h"
#import "ViolaInstance.h"
#import "VAConvertUtl.h"
#import "VAComponent+private.h"
#import "VAWeakObject.h"
#import "VADefine.h"
#import "ViolaInstance.h"
#import "VABridgeManager.h"

@implementation VAComponent 
static int componentAllocCount;
- (instancetype)initWithRef:(NSString *)ref
                       type:(NSString*)type
                     styles:(nullable NSDictionary *)styles
                 attributes:(nullable NSDictionary *)attributes
                     events:(nullable NSArray *)events
               weexInstance:(ViolaInstance *)violaInstance{
    if(self = [super init]){
        _ref = ref;
        _type = type;
        _styles = [VAConvertUtl convertToMutableDictionary:styles];
        _attributes = [VAConvertUtl convertToMutableDictionary:attributes];
        _events = [VAConvertUtl convertToMutableArray:events];
        _vaInstance = violaInstance;
        _subcomponents = [NSMutableArray array];
        
        //layout
        [self _initLayoutWithStyles:_styles];
        //view
        [self _initViewPropWithStyles:_styles];
        //event
        [self _initEvents:_events];
        componentAllocCount++;
    }
    return self;
}


- (NSString *)ref{
    return _ref;
}

- (NSString *)type
{
    return _type;
}

- (VAComponent *)supercomponent
{
    return _supercomponent;
}

- (NSMutableArray *)subcomponents
{
    return _subcomponents;
}

- (UIColor *)backgroundColor{
    return _backgroundColor;
}

- (ViolaInstance *)violaInstance{
    return _vaInstance;
}

- (CGRect)componentFrame{
    return _componentFrame;
}


- (UIEdgeInsets)contentEdge{
    return _contentEdge;
}



- (void)viewWillLoad
{
    VAAssertMainThread();
}

- (void)viewDidLoad
{
    VAAssertMainThread();
}

- (void)viewWillUnload
{
    VAAssertMainThread();
}

- (void)viewDidUnload
{
    VAAssertMainThread();
}

- (void)componentFrameDidChangeOnMainQueue{
    VAAssertMainThread();
}

- (void)updateComponentOnComponentThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events{
    VAAssertComponentThread();
}

- (void)updateComponentOnMainThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events{
    VAAssertMainThread();
}


- (void)addTaskToMainQueueOnComponentThead:(dispatch_block_t)block{
   
    [self addTaskToMainQueueOnComponentThead:block withAnimated:false];
}
- (void)addTaskToMainQueueOnComponentThead:(dispatch_block_t)block withAnimated:(BOOL)animated{
    kBlockWeakSelf;
    [VAThreadManager performOnComponentThreadWithBlock:^{
        [weakSelf.violaInstance.componentController addTaskToMainQueueOnComponentThead:block withAnimated:animated];
    }];

}

- (void)fireEventWithName:(NSString *)eventName params:(NSDictionary *)eventData{
    [[VABridgeManager shareManager] fireEventWithIntanceID:_vaInstance.instanceId ref:_ref type:eventName params:eventData domChanges:nil];
}

- (void)didInsertSubcomponent:(VAComponent *)subcomponent atIndex:(NSInteger)index{}
- (void)didRemoveFromSupercomponent{}
- (void)didMoveToSupercomponent:(VAComponent *)newSupercomponent{}

#pragma mark update

- (void)_updateAttributesOnComponentThread:(NSDictionary *)attributes
{
    VAAssertComponentThread();
    [_attributes addEntriesFromDictionary:attributes];
    [self updateAttributesOnComponentThread:attributes];
}

- (void)_updateAttributesOnMainThread:(NSDictionary *)attributes
{
    VAAssertMainThread();
    [self updateStylesOnMainThread:attributes];
}

- (void)_updateStylesOnComponentThread:(NSDictionary *)styles{
    VAAssertComponentThread();
    [_styles addEntriesFromDictionary:styles];
    [self _updateLayoutWithStyles:styles];
    [self _updateViewPropsOnComponentThreadWithStyles:styles];
    [self updateStylesOnComponentThread:styles];
}

- (void)_updateStylesOnMainThread:(NSDictionary *)styles{
    VAAssertMainThread();
    [self _updateViewPropOnMainTheadWithStyles:styles];
    [self updateStylesOnMainThread:styles];
}

- (void)updateEventsOnComponentThread:(NSArray *)events{
    VAAssertComponentThread();
}
- (void)updateEventsOnMainThread:(NSArray *)events{
    VAAssertMainThread();
}

- (BOOL)isBodyLayoutFinish{
    return self.violaInstance.componentController.isBodyLayoutFinish;
}



#pragma private

- (void)_insertSubcomponent:(VAComponent *)subcomponent atIndex:(NSInteger)index{
    VAAssertComponentThread();
    VAAssertReturn(subcomponent, @"can't be nil");
    
    subcomponent->_supercomponent = self;
    
    [_subcomponents insertObject:subcomponent atIndex:index];

    
    
    
    if (subcomponent->_positionType == VALayoutPositionFixed) {
//        [_vaInstance.componentController addFixedComponent:subcomponent]; //todo tomqiu
    }
    [self setNeedsLayout];
    [self didInsertSubcomponent:subcomponent atIndex:index];
    [subcomponent didMoveToSupercomponent:self];
}

- (void)_removeSubcomponent:(VAComponent *)subcomponent{
     VAAssertReturn(subcomponent, @"can't be nil");
    [_subcomponents removeObject:subcomponent];
    [self setNeedsLayout];
}

- (void)_removeFromSupercomponent{
    [self.supercomponent _removeSubcomponent:self];
    [self.supercomponent setNeedsLayout];
    
    if (_positionType == VALayoutPositionFixed) {
     // [_vaInstance.componentController removeFixedComponent:self]; //todo tomqiu
    }
    [self didRemoveFromSupercomponent];
}

- (void)_moveToSupercomponent:(VAComponent *)newSupercomponent atIndex:(NSUInteger)index{
    [self _removeFromSupercomponent];
    [newSupercomponent _insertSubcomponent:self atIndex:index];
}





#pragma mark - public
//更新回调
- (void)updateAttributesOnComponentThread:(NSDictionary *)attributes{
    VAAssertComponentThread();
}

- (void)updateAttributesOnMainThread:(NSDictionary *)attributes{
    VAAssertMainThread();
}

- (void)updateStylesOnComponentThread:(NSDictionary *)styles{
    VAAssertComponentThread();
}
- (void)updateStylesOnMainThread:(NSDictionary *)styles{
    VAAssertMainThread();
}

- (void)dealloc{
    VALogDebug(@"%s_componentAllocCount:%d,ref:%@",__func__,--componentAllocCount,self.ref);
}

- (void)addEventOnComponentThread:(NSString *)event{
    VAAssertComponentThread();
}
- (void)addEventOnMainThread:(NSString *)event{
    VAAssertMainThread();
}
- (void)removeEventOnComponentThread:(NSString *)event{
    VAAssertComponentThread();
}
- (void)removeEventOnMainThread:(NSString *)event{
    VAAssertMainThread();
}

@end


//category

@implementation UIView (VAComponent)

- (VAComponent *)va_component
{
    VAWeakObject * value = objc_getAssociatedObject(self, @selector(va_component));
    return value.weakObject;
}

- (void)setVa_component:(VAComponent *)va_component
{
    VAWeakObject * value = [[VAWeakObject alloc] init];
    value.weakObject = va_component;
    objc_setAssociatedObject(self, @selector(va_component), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
