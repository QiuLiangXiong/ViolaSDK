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
#import "VATransform.h"

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
    NSNumber * _touchEnable;
    VATransform * _transform;
    
    UIEdgeInsets _contentEdge;//内容边距  包括padding 和 borderWidth
    
    
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
    
    CAShapeLayer * _borderMaskLayer;
    CAShapeLayer * _borderLayer;
    CAShapeLayer * _borderTopLayer;
    CAShapeLayer * _borderBottomLayer;
    CAShapeLayer * _borderLeftLayer;
    CAShapeLayer * _borderRightLayer;
    
    
    //events
    BOOL _singleClickEnable;
    BOOL _doubleClickEnable;
    BOOL _longPressEnable;
    BOOL _panEnable;
    BOOL _swipeLeftEnable;//swipe 有四个方向。。。
    BOOL _swipeRightEnable;
    BOOL _swipeTopEnable;
    BOOL _swipeBottomEnable;
    UITapGestureRecognizer *_tapGesture;
    UITapGestureRecognizer *_doubleTapGesture;
    UILongPressGestureRecognizer *_longPressGesture;
    UIPanGestureRecognizer *_panGesture;
    UISwipeGestureRecognizer *_swipeLeftGesture;
    UISwipeGestureRecognizer *_swipeRightGesture;
    UISwipeGestureRecognizer *_swipeTopGesture;
    UISwipeGestureRecognizer *_swipeBottomGesture;

}
//+layout
- (void) _initLayoutWithStyles:(NSDictionary *)styles;
- (void)_updateLayoutWithStyles:(NSDictionary *)styles;
- (void)_syncCSSNodeLayoutWithDirtyComponents:(NSMutableArray *)dirtyComponents;
- (int)_getChildrenCountForCSSNode;
//+view
- (void)_initViewPropWithStyles:(NSDictionary *)styles;//on component thread
- (void)_updateViewPropOnMainTheadWithStyles:(NSDictionary *)styles;//on main thread
- (void)_updateViewPropsOnComponentThreadWithStyles:(NSDictionary *)styles;
//event
- (void)_initEvents:(NSMutableArray *)events;
- (void)_updateEventsOnComponentThread:(NSArray *)events;
- (void)_updateEventsOnMainThread:(NSArray *)events;
- (void)_syncTouchEventsToView;
- (void)onSingleClickWithSender:(id)sender;
- (void)_fireEventWithName:(NSString *)name extralParam:(NSDictionary *)param;
- (void)onDoubleClickWithSender:(id)sender;
- (void)onLongPressWithSender:(UILongPressGestureRecognizer *)sender;
- (void)onSwipeTopWithSender:(id)sender;
- (void)onSwipeBottomWithSender:(id)sender;
- (void)onSwipeLeftWithSender:(id)sender;
- (void)onSwipeRightWithSender:(id)sender;
- (void)onPanWithSender:(UIPanGestureRecognizer *)panGR;

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
