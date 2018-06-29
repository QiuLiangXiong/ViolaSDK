//
//  VAComponent+layout.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/6/23.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAComponent+layout.h"
#import "VAComponent+private.h"
#import "VADefine.h"
#import "VAConvertUtl.h"
#import "ViolaInstance.h"

@implementation VAComponent (layout)

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

#pragma mark - layout

- (void) _initLayoutWithStyles:(NSDictionary *)styles{
    _cssNode = new_css_node();
    _cssNode->context = (__bridge void *)self;
    _cssNode->is_dirty = cssNode_isDirty;
    _cssNode->get_child = cssNode_getChild;
    _cssNode->children_count = cssNode_childrenCount;
    if ([self calculateComponentSizeBlock]) {
        _cssNode->measure = cssNode_measure;
    }
     _cssNode->print = cssNode_print;
    [self _fillCSSNodeWithStyles:styles];
}

- (void)_updateLayoutWithStyles:(NSDictionary *)styles
{
    VAAssertComponentThread();
    if([styles isKindOfClass:[NSDictionary class]] && styles.allKeys.count){//update condition
        [self _fillCSSNodeWithStyles:styles];
    }
}


- (void)_syncCSSNodeLayoutWithDirtyComponents:(NSMutableArray *)dirtyComponents
{
    VAAssertComponentThread();
    if (!_cssNode->layout.should_update) return ;//无需更新
    _cssNode->layout.should_update = NO;
    _isLayoutDirty = NO;
    CGRect newFrame = CGRectMake(VARoundValue(_cssNode->layout.position[CSS_LEFT]),VARoundValue(_cssNode->layout.position[CSS_TOP]),
                                 VARoundValue(_cssNode->layout.dimensions[CSS_WIDTH]),VARoundValue(_cssNode->layout.dimensions[CSS_HEIGHT]));
    if (!CGRectEqualToRect(newFrame, _componentFrame)) {
        [self componentFrameWillChange];
        _componentFrame = newFrame;
        [dirtyComponents addObject:self];
        [self componentFrameDidChange];//componentFrame 发生变化
    }
    resetNodeLayout(_cssNode);
    if(_subcomponents.count){
        for (VAComponent *subcomponent in _subcomponents) {
            [subcomponent _syncCSSNodeLayoutWithDirtyComponents:dirtyComponents];
        }
    }
}

#pragma mark - private


#pragma mark cssNode callback

static void cssNode_print(void *context){
    //c语言
    VAComponent *component = (__bridge VAComponent *)context;
    printf("ref:%s type:%s ", component->_ref.UTF8String, component->_type.UTF8String);
}


static int cssNode_childrenCount(void * context){
    VAComponent *component = (__bridge VAComponent *)context;
    return (int)component->_subcomponents.count;
}

static css_node_t* cssNode_getChild(void *context, int i){
    VAComponent *component = (__bridge VAComponent *)context;
    NSArray *subcomponents = component->_subcomponents;
    if(i >= 0 && i < subcomponents.count){
        VAComponent *child = subcomponents[i];
        return child->_cssNode;
    }
    VAAssert(0, @"cssNode not found");
    return NULL;
}

static bool cssNode_isDirty(void * context){
    VAComponent *component = (__bridge VAComponent *)context;
    return [component isNeedsLayout];
}

static css_dim_t cssNode_measure(void *context, float width, css_measure_mode_t widthMode, float height, css_measure_mode_t heightMode){
    VAComponent *component = (__bridge VAComponent *)context;
    CGSize (^calculateComponentSizeBlock)(CGSize) = [component calculateComponentSizeBlock];
    if(calculateComponentSizeBlock){
        CGSize componentSize = calculateComponentSizeBlock(CGSizeMake(width, height));
        return (css_dim_t){componentSize.width, componentSize.height};
    }
    return (css_dim_t){NAN, NAN};
}


#pragma mark - public

- (CGSize (^)(CGSize))calculateComponentSizeBlock{
    return nil;
}

- (void)setNeedsLayout{
    VAComponent *supercomponent = self->_supercomponent;
    _isLayoutDirty = YES;
    if(supercomponent){
        [supercomponent setNeedsLayout];
    }
    if (self.isRootComponent) {
        [_vaInstance.componentController setNeedsLayout];
    }
}

- (BOOL)isNeedsLayout{
    return _isLayoutDirty;
}
//布局结束
- (void)layoutDidEnd{
    VAAssertMainThread();
    if (_positionType == VALayoutPositionSticky) {
//        [self.ancestorScroller adjustSticky]; //todo tomqiu
    }
}





#pragma mark - fill cssNode

#define VA_LAYOUT_FILL_CSS_NODE(key, prop, converToType)\
do {\
  id value = styles[@#key];\
  if (value) {\
      typeof(_cssNode->style.prop) cValue = (typeof(_cssNode->style.prop))[VAConvertUtl converToType:value];\
      _cssNode->style.prop = cValue;\
      needLayout = true;\
  }\
}while(0);

#define VA_LAYOUT_FILL_CSS_NODE_ALL_DIRECTION(key, prop)\
VA_LAYOUT_FILL_CSS_NODE(key, prop[CSS_TOP], convertToFloatWithPixel);\
VA_LAYOUT_FILL_CSS_NODE(key, prop[CSS_LEFT], convertToFloatWithPixel);\
VA_LAYOUT_FILL_CSS_NODE(key, prop[CSS_RIGHT], convertToFloatWithPixel);\
VA_LAYOUT_FILL_CSS_NODE(key, prop[CSS_BOTTOM], convertToFloatWithPixel);


- (void)_fillCSSNodeWithStyles:(NSDictionary *)styles{
    VAAssertReturn([styles isKindOfClass:[NSDictionary class]], @"style type error");

    BOOL needLayout = false;
    VA_LAYOUT_FILL_CSS_NODE(flex, flex, convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(flexDirection, flex_direction, css_flex_direction_t)
    VA_LAYOUT_FILL_CSS_NODE(alignItems, align_items, css_align_t)
    VA_LAYOUT_FILL_CSS_NODE(alignSelf, align_self, css_align_t)
    VA_LAYOUT_FILL_CSS_NODE(flexWrap, flex_wrap, css_wrap_type_t)
    VA_LAYOUT_FILL_CSS_NODE(justifyContent, justify_content, css_justify_t)
    
    VA_LAYOUT_FILL_CSS_NODE(position, position_type, css_position_type_t)
    VA_LAYOUT_FILL_CSS_NODE(top, position[CSS_TOP], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(left, position[CSS_LEFT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(right, position[CSS_RIGHT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(bottom, position[CSS_BOTTOM], convertToFloatWithPixel)
    
    VA_LAYOUT_FILL_CSS_NODE(width, dimensions[CSS_WIDTH], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(height, dimensions[CSS_HEIGHT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(minWidth, minDimensions[CSS_WIDTH], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(minHeight, minDimensions[CSS_HEIGHT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(maxWidth, maxDimensions[CSS_WIDTH], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(maxHeight, maxDimensions[CSS_HEIGHT], convertToFloatWithPixel)
    
    VA_LAYOUT_FILL_CSS_NODE_ALL_DIRECTION(margin, margin)
    VA_LAYOUT_FILL_CSS_NODE(marginTop, margin[CSS_TOP], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(marginLeft, margin[CSS_LEFT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(marginRight, margin[CSS_RIGHT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(marginBottom, margin[CSS_BOTTOM], convertToFloatWithPixel)
    
    VA_LAYOUT_FILL_CSS_NODE_ALL_DIRECTION(borderWidth, border)
    VA_LAYOUT_FILL_CSS_NODE(borderTopWidth, border[CSS_TOP], convertToFloatWithPixel);
    VA_LAYOUT_FILL_CSS_NODE(borderLeftWidth, border[CSS_LEFT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(borderRightWidth, border[CSS_RIGHT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(borderBottomWidth, border[CSS_BOTTOM], convertToFloatWithPixel)
    
    VA_LAYOUT_FILL_CSS_NODE_ALL_DIRECTION(padding, padding)
    VA_LAYOUT_FILL_CSS_NODE(paddingTop, padding[CSS_TOP], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(paddingLeft, padding[CSS_LEFT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(paddingRight, padding[CSS_RIGHT], convertToFloatWithPixel)
    VA_LAYOUT_FILL_CSS_NODE(paddingBottom, padding[CSS_BOTTOM], convertToFloatWithPixel)
    
    if(needLayout){
        _contentEdge = UIEdgeInsetsMake(_cssNode->style.padding[CSS_TOP] + _cssNode->style.border[CSS_TOP],
                                        _cssNode->style.padding[CSS_LEFT] + _cssNode->style.border[CSS_LEFT],
                                        _cssNode->style.padding[CSS_BOTTOM] + _cssNode->style.border[CSS_BOTTOM],
                                        _cssNode->style.padding[CSS_RIGHT] + _cssNode->style.border[CSS_RIGHT]);
        [self setNeedsLayout];
    }
}

@end
