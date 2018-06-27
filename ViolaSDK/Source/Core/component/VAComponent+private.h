//
//  VAComponent+private.h
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/6/23.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#ifndef VAComponent_private_h
#define VAComponent_private_h
#import "Layout.h"
#import "VAConvertUtl.h"

@interface VAComponent ()
{
    @package
   //base
    NSString *_ref;
    NSString *_type;
    NSMutableDictionary *_styles;//must be in component thread
    NSMutableDictionary *_attributes;//must be in component thread
    NSMutableArray *_events;//must be in component thread
    __weak ViolaInstance *_vaInstance;
    __weak VAComponent *_supercomponent;
    NSMutableArray *_subcomponents;//must be in component thread
    
   //layout
    css_node_t *_cssNode;//must be in component thread
    BOOL _isLayoutDirty;
    CGRect _componentFrame;
    CGPoint _absolutePosition;
    VALayoutPosition _positionType;

    UIColor *_backgroundColor;
    BOOL   _clipToBounds;
    UIView *_view;
    BOOL _visibility;
    CGFloat _opacity;
    
    //border
    UIColor *_borderTopColor;
    UIColor *_borderRightColor;
    UIColor *_borderLeftColor;
    UIColor *_borderBottomColor;
    
    CGFloat _borderTopWidth;
    CGFloat _borderRightWidth;
    CGFloat _borderLeftWidth;
    CGFloat _borderBottomWidth;
    
    CGFloat _borderTopLeftRadius;
    CGFloat _borderTopRightRadius;
    CGFloat _borderBottomLeftRadius;
    CGFloat _borderBottomRightRadius;
    
    VABorderStyle _borderTopStyle;
    VABorderStyle _borderRightStyle;
    VABorderStyle _borderBottomStyle;
    VABorderStyle _borderLeftStyle;

}
//+layout
- (void) _initLayoutWithStyles:(NSDictionary *)styles;
- (void)_updateLayoutWithStyles:(NSDictionary *)styles;
- (void)_syncCSSNodeLayoutWithDirtyComponents:(NSMutableArray *)dirtyComponents;
//+view
- (void)_initViewPropWithStyles:(NSDictionary *)styles;//on component thread
- (void)_updateViewPropWithStyles:(NSDictionary *)styles;//on main thread
//event
- (void)_initEvents:(NSMutableArray *)events;

//update
- (void)_updateAttributesOnComponentThread:(NSDictionary *)attributes;
- (void)_updateAttributesOnMainThread:(NSDictionary *)attributes;
- (void)_updateStylesOnComponentThread:(NSDictionary *)styles;
- (void)_updateStylesOnMainThread:(NSDictionary *)styles;

- (void)_insertSubcomponent:(VAComponent *)subcomponent atIndex:(NSInteger)index;

- (void)_removeSubcomponent:(VAComponent *)subcomponent;
- (void)_removeFromSupercomponent;
- (void)_moveToSupercomponent:(VAComponent *)newSupercomponent atIndex:(NSUInteger)index;
@end


#endif /* VAComponent_private_h */
