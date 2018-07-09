//
//  VComponent+view.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/6/25.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAComponent+view.h"
#import "VAComponent+private.h"
#import "VADefine.h"
#import "VAConvertUtl.h"
#import "ViolaInstance.h"

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@interface VAComponent()


@end

@implementation VAComponent (view)


#pragma mark - init

- (void)_initViewPropWithStyles:(NSDictionary *)styles{
    styles = [styles isKindOfClass:[NSDictionary class]] ? styles : nil;
    _visibility = [VAConvertUtl convertToBOOLWithVisibilityValue:styles[@"visibility"] defaultValue:YES];
    _opacity = [VAConvertUtl convertToFloat:styles[@"opacity"] defaultValue:1.0f];
    _clipToBounds =  [VAConvertUtl convertToBOOLWithClipValue:styles[@"overflow"] defaultValue:NO];
    _backgroundColor = [VAConvertUtl convertToColor:styles[@"backgroundColor"] defaultValue:[UIColor clearColor]];
    _positionType = [VAConvertUtl converToPosition:styles[@"position"] defaultValue:(VALayoutPositionRelative)];
    
    if (styles[@"touchEnable"]) {
        _touchEnable = @([VAConvertUtl convertToBOOL:styles[@"touchEnable"]]);
    }
    if(styles[@"animated"]){
        self.animatedEnable = [VAConvertUtl convertToBOOL:styles[@"animated"]];
    }
    //transform  特殊
    _transform = [VAConvertUtl converToTransform:styles[@"transform"] origin:styles[@"transformOrigin"]];
    //    _transform = styles[@"transform"] || styles[@"transformOrigin"] ?//todo tomqiu  transform //这个一般和动画相关
     //todo tomqiu  transform and border
    
    [self _fillBorderWithStyles:styles];

}

- (void)_updateViewPropsOnComponentThreadWithStyles:(NSDictionary *)styles{
    if(styles[@"animated"]){
        self.animatedEnable = [VAConvertUtl convertToBOOL:styles[@"animated"]];
    }
    if (styles[@"position"]) {
        _positionType = [VAConvertUtl converToPosition:styles[@"position"]];
    }
}
- (void)_updateViewPropOnMainTheadWithStyles:(NSDictionary *)styles{
    VAAssertMainThread();
    if (styles[@"visibility"]) {
        _visibility = [VAConvertUtl convertToBOOLWithVisibilityValue:styles[@"visibility"]];
        _view.hidden = !_visibility;
    }
    if (styles[@"opacity"]) {
        _opacity = [VAConvertUtl convertToFloat:styles[@"opacity"]];
        _view.alpha = _opacity;
    }
    if (styles[@"overflow"]) {
        _clipToBounds = [VAConvertUtl convertToBOOLWithClipValue:styles[@"overflow"]];
        _view.clipsToBounds = _clipToBounds;
    }
    
    if (styles[@"backgroundColor"]) {
        _backgroundColor = [VAConvertUtl convertToColor:styles[@"backgroundColor"]];
        _view.backgroundColor = _backgroundColor;
    }
    
    if (styles[@"touchEnable"]) {
        _touchEnable = @([VAConvertUtl convertToBOOLWithClipValue:styles[@"touchEnable"]]);
        _view.userInteractionEnabled = [_touchEnable boolValue];
    }
    VATransform * transform = [VAConvertUtl converToTransform:styles[@"transform"] origin:styles[@"transformOrigin"]];
    if (transform) {
        _transform = transform;
        [_transform transformToView:self.view];
    }
    
    if([self _fillBorderWithStyles:styles]){
        [self _syncBorderRadiusAndDraw];
    }
}

#define VA_FILL_BORDER(key,prop,method)\
if(styles[@#key]){\
    prop = [VAConvertUtl method:styles[@#key]];\
    update = true;\
}
#define VA_FILL_ALL_BORDER(key,prop0,prop1,prop2,prop3,method)\
if(styles[@#key]){\
   prop0 = prop1 = prop2 = prop3 = [VAConvertUtl method:styles[@#key]];\
   update = true;\
}


- (BOOL)_fillBorderWithStyles:(NSDictionary *)styles{
    BOOL update = false;
   VA_FILL_ALL_BORDER(borderRadius,_borderTopLeftRadius,_borderTopRightRadius,_borderBottomLeftRadius,_borderBottomRightRadius,convertToFloatWithPixel);
   VA_FILL_BORDER(borderTopLeftRadius, _borderTopLeftRadius, convertToFloatWithPixel);
   VA_FILL_BORDER(borderTopRightRadius, _borderTopRightRadius, convertToFloatWithPixel);
   VA_FILL_BORDER(borderBottomRightRadius, _borderBottomRightRadius, convertToFloatWithPixel);
   VA_FILL_BORDER(borderBottomLeftRadius, _borderBottomLeftRadius, convertToFloatWithPixel);

   VA_FILL_ALL_BORDER(borderWidth,_borderTopWidth,_borderRightWidth,_borderBottomWidth,_borderLeftWidth,convertToFloatWithPixel);
   VA_FILL_BORDER(borderTopWidth, _borderTopWidth, convertToFloatWithPixel);
   VA_FILL_BORDER(borderRightWidth, _borderRightWidth, convertToFloatWithPixel);
   VA_FILL_BORDER(borderLeftWidth, _borderLeftWidth, convertToFloatWithPixel);
   VA_FILL_BORDER(borderBottomWidth, _borderBottomWidth, convertToFloatWithPixel);
    
   VA_FILL_ALL_BORDER(borderColor,_borderTopColor,_borderRightColor,_borderBottomColor,_borderLeftColor,convertToColor);
   VA_FILL_BORDER(borderTopColor, _borderTopColor, convertToColor);
   VA_FILL_BORDER(borderRightColor, _borderRightColor, convertToColor);
   VA_FILL_BORDER(borderLeftColor, _borderLeftColor, convertToColor);
   VA_FILL_BORDER(borderBottomColor, _borderBottomColor, convertToColor);
    

   VA_FILL_ALL_BORDER(borderStyle,_borderTopStyle,_borderRightStyle,_borderBottomStyle,_borderLeftStyle,converToBorderStyle);
   VA_FILL_BORDER(borderTopStyle, _borderTopStyle, converToBorderStyle);
   VA_FILL_BORDER(borderBottomStyle, _borderBottomStyle, converToBorderStyle);
   VA_FILL_BORDER(borderLeftStyle, _borderLeftStyle, converToBorderStyle);
   VA_FILL_BORDER(borderRightStyle, _borderRightStyle, converToBorderStyle);
    
   
    
    return update;
}


#pragma mark Public

- (UIView *)loadView{
    return [[UIView alloc] init];
}

- (BOOL)isViewLoaded{
    return _view != nil;
}

- (void)insertSubview:(VAComponent *)subcomponent atIndex:(NSUInteger)index{
    VAAssertMainThread();
    //todo tomqiu lazyCreateView逻辑
    
    VAAssertReturn(subcomponent, @"can't be nil");
    if(subcomponent.view.superview){
      [subcomponent.view removeFromSuperview];//有父亲先删除
    }
    [subcomponent willMoveToSuperview:self.view];
    [self.view insertSubview:subcomponent.view atIndex:index];
    [subcomponent didMoveToSuperview];
    [self _adjustBorderLayerToFront];
    
}

- (void)moveToSuperview:(VAComponent *)supercomponent atIndex:(NSUInteger)index{
    VAAssertMainThread();
    [self removeFromSuperview];
    [self.view didMoveToSuperview];
    [supercomponent insertSubview:self atIndex:index];
}

- (void)removeFromSuperview{
    VAAssertMainThread();
    if ([self isViewLoaded]) {
        [self.view removeFromSuperview];
    }
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview{
    VAAssertMainThread();
}
- (void)didMoveToSuperview{
    VAAssertMainThread();
}
//component view 变化

- (void)componentFrameWillChange{
    //组件线程
    //
}

- (void)mainQueueWillSyncBeforeAnimation{
    VAAssertMainThread();
    
    if (![self isViewLoaded]) {
        self.view.frame = CGRectMake(_componentFrame.origin.x, _componentFrame.origin.y, _componentFrame.size.width, 0);
    }
}

- (void)componentFrameDidChange{
     //todo tomqiu
    kBlockWeakSelf;
    [_vaInstance.componentController addTaskToMainQueueOnComponentThead:^{
        [weakSelf _componentFrameDidChange];
        [weakSelf componentFrameDidChangeOnMainQueue];
    }];
}






#pragma mark Property

- (UIView *)view{
   
    if ([self isViewLoaded]) {
        return _view;
    } else {
        VAAssertMainThread();
        
        [self viewWillLoad];
        _view = [self loadView];
        _view.va_component = self;
        _view.frame = _componentFrame;
        _view.hidden = !_visibility;
        _view.clipsToBounds = _clipToBounds;
        _view.backgroundColor = _backgroundColor;
        _view.alpha = _opacity;
        if (_touchEnable) {
            _view.userInteractionEnabled = [_touchEnable boolValue];
        }
        [self _syncTouchEventsToView];
        
        [self viewDidLoad];
        return _view;
    }
}


#pragma mark - private

- (void)_componentFrameDidChange{
    //
    
    if (_transform) {
        self.view.transform = CGAffineTransformIdentity;
    }
    self.view.frame = _componentFrame;
    if (_transform) {
        [_transform transformToView:self.view];
    }
    
    //圆角
   [self _syncBorderRadiusAndDraw];
    //
}



- (void)_syncBorderRadiusAndDraw{
    CGFloat borderTopLeftRadius = 0;
    CGFloat borderTopRightRadius = 0;
    CGFloat borderBottomLeftRadius = 0;
    CGFloat borderBottomRightRadius = 0;
    //开始切圆角
    if(_borderTopLeftRadius || _borderTopRightRadius || _borderBottomLeftRadius || _borderBottomRightRadius){
        //圆角
        CGSize size = _view.bounds.size;
        CGFloat maxLength = fmin(size.width, size.height);//最短边作为最大长度
        borderTopLeftRadius = fmin(_borderTopLeftRadius, maxLength);
        borderTopRightRadius = fmin(_borderTopRightRadius, maxLength);
        borderBottomLeftRadius = fmin(_borderBottomLeftRadius, maxLength);
        borderBottomRightRadius = fmin(_borderBottomRightRadius, maxLength);
        
        if(borderTopLeftRadius + borderBottomLeftRadius > size.height){
            borderTopLeftRadius = size.height * (_borderTopLeftRadius / (_borderTopLeftRadius + _borderBottomLeftRadius));
            borderBottomLeftRadius = size.height - borderTopLeftRadius;
        }
        if(borderTopRightRadius + borderBottomRightRadius > size.height){
            borderTopRightRadius = size.height * (_borderTopRightRadius / (_borderTopRightRadius + _borderBottomRightRadius));
            borderBottomRightRadius = size.height - borderTopRightRadius;
        }
        if(borderTopLeftRadius + borderTopRightRadius > size.width){
            borderTopLeftRadius = maxLength * (_borderTopLeftRadius / (_borderTopLeftRadius + _borderTopRightRadius));
            borderTopRightRadius = maxLength - borderTopLeftRadius;
        }
        if(borderBottomLeftRadius + borderBottomRightRadius > size.width){
            borderBottomLeftRadius = maxLength * (_borderBottomLeftRadius / (_borderBottomLeftRadius + _borderBottomRightRadius));
            borderBottomRightRadius = maxLength - borderBottomLeftRadius;
        }
        UIBezierPath * path = [UIBezierPath bezierPath];
        CGFloat radius = borderTopLeftRadius;
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:M_PI * (3/2.0f) clockwise:true];
        radius = borderTopRightRadius;
        [path addLineToPoint:CGPointMake(size.width - radius, 0)];
        [path addArcWithCenter:CGPointMake(size.width - radius, radius) radius:radius startAngle:M_PI * (3/2.0f) endAngle:2 * M_PI clockwise:true];
        radius = borderBottomRightRadius;
        [path addLineToPoint:CGPointMake(size.width, size.height - radius)];
        [path addArcWithCenter:CGPointMake(size.width - radius, size.height - radius) radius:radius startAngle:2 * M_PI endAngle:M_PI_2 clockwise:YES];
        radius = borderBottomLeftRadius;
        [path addLineToPoint:CGPointMake(radius, size.height)];
        [path addArcWithCenter:CGPointMake(radius, size.height - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [path closePath];
        if(!_borderMaskLayer){
            _borderMaskLayer = [CAShapeLayer layer];
        }
        _borderMaskLayer.frame = _view.bounds;
        _borderMaskLayer.path = path.CGPath;
        if(!_view.layer.mask){
            _view.layer.mask = _borderMaskLayer;
        }
    }else {
        if(_borderMaskLayer && _view.layer.mask == _borderMaskLayer){
            _view.layer.mask = nil;
        }
        _borderMaskLayer = nil;
    }

    [self _syncBorderDrawWithTopLeft:borderTopLeftRadius topRight:borderTopRightRadius bottomLeft:borderBottomLeftRadius bottomTop:borderBottomRightRadius];

}




- (void)_syncBorderDrawWithTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomTop:(CGFloat)bottomRight{
    _borderLayer.hidden = true;
    _borderTopLayer.hidden = true;
    _borderBottomLayer.hidden = true;
    _borderLeftLayer.hidden = true;
    _borderRightLayer.hidden = true;
    CGSize size = _view.bounds.size;
    if([self __isSameBorder]){
        
        if(_borderTopLeftRadius == 0 && _borderTopRightRadius == 0 && _borderBottomLeftRadius == 0 && _borderBottomRightRadius == 0 && _borderLeftStyle == VABorderStyleSolid){
            _view.layer.borderColor = _borderTopColor.CGColor ? : [UIColor clearColor].CGColor;
            _view.layer.borderWidth = _borderTopWidth;
        }else {
            _view.layer.borderColor = nil;
            _view.layer.borderWidth = 0;
                    if(!_borderLayer){
                        _borderLayer = [CAShapeLayer layer];
                        [_view.layer addSublayer:_borderLayer];
                    }
                    _borderLayer.frame = _view.bounds;
                    _borderLayer.hidden = false;
                    UIBezierPath * path = [UIBezierPath bezierPath];
                    CGFloat radius = topLeft;
                    [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:M_PI * (3/2.0f) clockwise:true];
                    radius = topRight;
                    [path addLineToPoint:CGPointMake(size.width - radius, 0)];
                    [path addArcWithCenter:CGPointMake(size.width - radius, radius) radius:radius startAngle:M_PI * (3/2.0f) endAngle:2 * M_PI clockwise:true];
                    radius = bottomRight;
                    [path addLineToPoint:CGPointMake(size.width, size.height - radius)];
                    [path addArcWithCenter:CGPointMake(size.width - radius, size.height - radius) radius:radius startAngle:2 * M_PI endAngle:M_PI_2 clockwise:YES];
                    radius = bottomLeft;
                    [path addLineToPoint:CGPointMake(radius, size.height)];
                    [path addArcWithCenter:CGPointMake(radius, size.height - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
                    [path closePath];
                    _borderLayer.fillColor = [UIColor clearColor].CGColor;
                    _borderLayer.strokeColor = _borderTopColor.CGColor ? : [UIColor clearColor].CGColor;
                    _borderLayer.lineWidth = 2 * _borderTopWidth;
            
                    if(_borderTopStyle == VABorderStyleDashed){
                         _borderLayer.lineDashPattern = @[@(3 * _borderTopWidth), @(3 * _borderTopWidth)];//画虚线
                    }else if(_borderTopStyle == VABorderStyleDotted){
                         _borderLayer.lineDashPattern = @[@(_borderTopWidth), @(_borderTopWidth)];//画点
                    }else {
                        _borderLayer.lineDashPattern = nil;
                    }
                    _borderLayer.path = path.CGPath;
        }
        
        

        
    }else {

        if(_borderTopWidth){
            if(!_borderTopLayer){
                _borderTopLayer = [CAShapeLayer layer];
                [_view.layer addSublayer:_borderTopLayer];
            }
            _borderTopLayer.frame = _view.bounds;
            _borderTopLayer.hidden = false;
            //四条边一条一条绘制
            CGMutablePathRef path = CGPathCreateMutable();
//            CGPathAddArc(path, NULL, 0, 0, 0, -M_PI_4 * 3, -M_PI_2, NO);
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, size.width, 0);
//            CGPathAddArc(path, NULL, size.width - 0, 0, 0, -M_PI_2, -M_PI_4, NO);
            _borderTopLayer.fillColor = [UIColor clearColor].CGColor;
            _borderTopLayer.strokeColor = _borderTopColor.CGColor ? : [UIColor clearColor].CGColor;
            _borderTopLayer.lineWidth = 2 * _borderTopWidth;
            if(_borderTopStyle == VABorderStyleDashed){
                _borderTopLayer.lineDashPattern = @[@(3 * _borderTopWidth), @(3 * _borderTopWidth)];//画虚线
            }else if(_borderTopStyle == VABorderStyleDotted){
                _borderTopLayer.lineDashPattern = @[@(_borderTopWidth), @(_borderTopWidth)];//画点
            }else {
                _borderTopLayer.lineDashPattern = nil;
            }
            _borderTopLayer.path = path;
            CGPathRelease(path);
        }
        if(_borderBottomWidth){
            if(!_borderBottomLayer){
                _borderBottomLayer = [CAShapeLayer layer];
                [_view.layer addSublayer:_borderBottomLayer];
            }
            _borderBottomLayer.frame = _view.bounds;
            _borderBottomLayer.hidden = false;
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, size.height);
            CGPathAddLineToPoint(path, NULL, size.width, size.height);
            _borderBottomLayer.fillColor = [UIColor clearColor].CGColor;
            _borderBottomLayer.strokeColor = _borderBottomColor.CGColor? : [UIColor clearColor].CGColor;;
            _borderBottomLayer.lineWidth = 2 * _borderBottomWidth;
            _borderBottomLayer.path = path;
            if(_borderTopStyle == VABorderStyleDashed){
                _borderBottomLayer.lineDashPattern = @[@(3 * _borderBottomWidth), @(3 * _borderBottomWidth)];//画虚线
            }else if(_borderTopStyle == VABorderStyleDotted){
                _borderBottomLayer.lineDashPattern = @[@(_borderBottomWidth), @(_borderBottomWidth)];//画点
            }else {
                _borderBottomLayer.lineDashPattern = nil;
            }
            CGPathRelease(path);
        }
        if(_borderLeftWidth){
            if(!_borderLeftLayer){
                _borderLeftLayer = [CAShapeLayer layer];
                [_view.layer addSublayer:_borderLeftLayer];
            }
            _borderLeftLayer.frame = _view.bounds;
            _borderLeftLayer.hidden = false;
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, size.height);
            _borderLeftLayer.fillColor = [UIColor clearColor].CGColor;
            _borderLeftLayer.strokeColor = _borderLeftColor.CGColor ? : [UIColor clearColor].CGColor;;
            _borderLeftLayer.lineWidth = 2 * _borderLeftWidth;
            _borderLeftLayer.path = path;
            if(_borderTopStyle == VABorderStyleDashed){
                _borderLeftLayer.lineDashPattern = @[@(3 * _borderLeftWidth), @(3 * _borderLeftWidth)];//画虚线
            }else if(_borderTopStyle == VABorderStyleDotted){
                _borderLeftLayer.lineDashPattern = @[@(_borderLeftWidth), @(_borderLeftWidth)];//画点
            }else {
                _borderLeftLayer.lineDashPattern = nil;
            }
            CGPathRelease(path);
        }
        if(_borderRightWidth){
            if(!_borderRightLayer){
                _borderRightLayer = [CAShapeLayer layer];
                [_view.layer addSublayer:_borderRightLayer];
            }
            _borderRightLayer.frame = _view.bounds;
            _borderRightLayer.hidden = false;
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, size.width, 0);
            CGPathAddLineToPoint(path, NULL, size.width, size.height);
            _borderRightLayer.fillColor = [UIColor clearColor].CGColor;
            _borderRightLayer.strokeColor = _borderRightColor.CGColor ? : [UIColor clearColor].CGColor;;
            _borderRightLayer.lineWidth = 2 * _borderRightWidth;
            _borderRightLayer.path = path;
            if(_borderTopStyle == VABorderStyleDashed){
                _borderRightLayer.lineDashPattern = @[@(3 * _borderRightWidth), @(3 * _borderRightWidth)];//画虚线
            }else if(_borderTopStyle == VABorderStyleDotted){
                _borderRightLayer.lineDashPattern = @[@(_borderRightWidth), @(_borderRightWidth)];//画点
            }else {
                _borderRightLayer.lineDashPattern = nil;
            }
            CGPathRelease(path);
        }
        
        
        
    }
    
    if( (_borderLayer && !_borderLayer.hidden ) || (_borderTopLayer && !_borderTopLayer.hidden ) || (_borderLeftLayer && !_borderLeftLayer.hidden ) || (_borderRightLayer && !_borderRightLayer.hidden ) || (_borderBottomLayer && !_borderBottomLayer.hidden )){
        if(!_borderMaskLayer){
            _view.clipsToBounds = true;
        }
    }
}

- (BOOL)__isSameBorder{
    if(_borderTopWidth && (_borderTopWidth == _borderBottomWidth) && (_borderLeftWidth == _borderRightWidth) && (_borderTopWidth == _borderRightWidth) &&
       _borderTopColor == _borderBottomColor && _borderLeftColor == _borderRightColor && _borderTopColor ==  _borderRightColor &&
       _borderTopStyle == _borderBottomStyle && _borderLeftStyle == _borderRightStyle && _borderLeftStyle == _borderTopStyle
       ){
        return YES;
    }
    return NO;
}

- (void)_adjustBorderLayerToFront{
    [self _moveLayerToFrontWithLayer:_borderLayer];
    [self _moveLayerToFrontWithLayer:_borderBottomLayer];
    [self _moveLayerToFrontWithLayer:_borderTopLayer];
    [self _moveLayerToFrontWithLayer:_borderLeftLayer];
    [self _moveLayerToFrontWithLayer:_borderRightLayer];
}

-  (void)_moveLayerToFrontWithLayer:(CALayer *)layer{
    if (layer) {
        NSInteger index = [_view.layer.sublayers indexOfObject:layer];
        if (index >= 0 && index < _view.layer.sublayers.count - 1) {
            [layer removeFromSuperlayer];
            [_view.layer addSublayer:layer];
        }
    }
}




@end
