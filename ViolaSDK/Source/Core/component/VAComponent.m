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
    [self updateStylesOnComponentThread:styles];
}

- (void)_updateStylesOnMainThread:(NSDictionary *)styles{
    VAAssertMainThread();
    [self _updateViewPropWithStyles:styles];
    [self updateStylesOnMainThread:styles];
}


//todo tomqiu event
//- (void)_addEventOnComponentThread:(NSString *)eventName{
//    [_events addObject:eventName];
//}
//
//- (void)_removeEventOnComponentThread:(NSString *)eventName{
//    [_events removeObject:eventName];
//}

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
    VALogDebug(@"%s_componentAllocCount:%d",__func__,--componentAllocCount);
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
