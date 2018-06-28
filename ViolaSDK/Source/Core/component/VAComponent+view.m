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
   
    //todo tomqiu  transform and border
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
    [self.view insertSubview:subcomponent.view atIndex:index];
    
}

- (void)moveToSuperview:(VAComponent *)supercomponent atIndex:(NSUInteger)index{
    VAAssertMainThread();
    [self removeFromSuperview];
    [supercomponent insertSubview:self atIndex:index];
}

- (void)removeFromSuperview{
    VAAssertMainThread();
    if ([self isViewLoaded]) {
        [self.view removeFromSuperview];
    }
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
        _view.frame = _componentFrame;
        _view.hidden = !_visibility;
        _view.clipsToBounds = _clipToBounds;
        _view.backgroundColor = _backgroundColor;
        _view.alpha = _opacity;
        if (_touchEnable) {
            _view.userInteractionEnabled = [_touchEnable boolValue];
        }
        
//        if (![self _needsDrawBorder]) {
//            _layer.borderColor = _borderTopColor.CGColor;
//            _layer.borderWidth = _borderTopWidth;
//            [self _resetNativeBorderRadius];
//            _layer.opacity = _opacity;
//            _view.backgroundColor = _backgroundColor;
//        }
    
//        if (_transform) {
//            [_transform applyTransformForView:_view];
//        }
        
//        if (_boxShadow) {
//            [self configBoxShadow:_boxShadow];
//        }
        
        _view.va_component = self;
        [self viewDidLoad];//viewdidload
        [self _syncTouchEventsToView];
    //    [self _syncBorderDraw];
//        [self _createShapeLayer];
        
        return _view;
    }
}


#pragma mark - private

- (void)_componentFrameDidChange{
    self.view.frame = _componentFrame;
    //圆角
    [self _syncBorderRadiusAndDraw];
}



- (void)_syncBorderRadiusAndDraw{
    //开始切圆角
    if(_borderTopLeftRadius || _borderTopRightRadius || _borderBottomLeftRadius || _borderBottomRightRadius){
        //圆角
        CGSize size = _view.bounds.size;
        CGFloat maxLength = fmin(size.width, size.height);//最短边作为最大长度
        CGFloat borderTopLeftRadius = fmin(_borderTopLeftRadius, maxLength);
        CGFloat borderTopRightRadius = fmin(_borderTopRightRadius, maxLength);
        CGFloat borderBottomLeftRadius = fmin(_borderBottomLeftRadius, maxLength);
        CGFloat borderBottomRightRadius = fmin(_borderBottomRightRadius, maxLength);
        
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
        _borderTopLeftRadius = borderTopLeftRadius;
        _borderTopRightRadius = borderTopRightRadius;
        _borderBottomLeftRadius = borderBottomLeftRadius;
        _borderBottomRightRadius = borderBottomRightRadius;
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

    [self _syncBorderDraw];

}

    
    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddArc(path, NULL, leftUpCornerRadius, leftUpCornerRadius, leftUpCornerRadius, -M_PI_4 * 3, -M_PI_2, NO);
//    CGPathMoveToPoint(path, NULL, leftUpCornerRadius, 0);
//    CGPathAddLineToPoint(path, NULL, size.width - rightUpCornerRadius, 0);
//    CGPathAddArc(path, NULL, size.width - rightUpCornerRadius, rightUpCornerRadius, rightUpCornerRadius, -M_PI_2, -M_PI_4, NO);
    
    //
    //    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //    shapeLayer.frame = self.view.bounds;
    //    shapeLayer.path = path;
    //    shapeLayer.lineWidth = 10;
    //    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    //    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    //    CGPathRelease(path);
    //
    //    UIBezierPath * padfd = [UIBezierPath bezierPath];
    //
    
    



//- (BOOL)_isEqualWithRadius0:(CGFloat)radius0 radius1:(CGFloat)radius1 radius2:(CGFloat)radius2 radius3:(CGFloat)radius3{
//    CGFloat radius = fmax(radius3, fmax(radius2, fmax(radius0, radius1)));
//    if(radius0 && radius0 != radius){
//        return false;
//    }
//    if(radius1 && radius1 != radius){
//        return false;
//    }
//    if(radius2 && radius2 != radius){
//        return false;
//    }
//    if(radius3 && radius3 != radius){
//        return false;
//    }
//    return true;
//}

    
    
//    CGFloat leftUpCornerRadius = 10;
//    CGFloat rightUpCornerRadius = 30;
//    CGFloat leftDownCornerRadius = 20;
//    CGFloat rightDownCornerRadius = 40;
//    CGSize size = self.view.bounds.size;
//
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddArc(path, NULL, leftUpCornerRadius, leftUpCornerRadius, leftUpCornerRadius, -M_PI_4 * 3, -M_PI_2, NO);
//    CGPathMoveToPoint(path, NULL, leftUpCornerRadius, 0);
//    CGPathAddLineToPoint(path, NULL, size.width - rightUpCornerRadius, 0);
//    CGPathAddArc(path, NULL, size.width - rightUpCornerRadius, rightUpCornerRadius, rightUpCornerRadius, -M_PI_2, -M_PI_4, NO);
//
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.frame = self.view.bounds;
//    shapeLayer.path = path;
//    shapeLayer.lineWidth = 10;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
//    CGPathRelease(path);
//
//    UIBezierPath * padfd = [UIBezierPath bezierPath];
//
//
//    [_view.layer addSublayer:shapeLayer];
//
//
//    CGMutablePathRef path2 = CGPathCreateMutable();
//    CGPathAddArc(path2, NULL, size.width - rightUpCornerRadius, rightUpCornerRadius, rightUpCornerRadius, -M_PI_4, 0, NO);
//    CGPathMoveToPoint(path2, NULL, size.width, rightUpCornerRadius);
//    CGPathAddLineToPoint(path2, NULL, size.width, size.height - rightDownCornerRadius);
//    CGPathAddArc(path2, NULL, size.width - rightDownCornerRadius, size.height - rightDownCornerRadius, rightDownCornerRadius, 0, M_PI_4, NO);
//
//    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
//    shapeLayer2.frame = self.view.bounds;
//    shapeLayer2.path = path2;
//    shapeLayer2.lineWidth = 10;
//    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer2.strokeColor = [UIColor redColor].CGColor;
//    CGPathRelease(path2);
//
//    [_view.layer addSublayer:shapeLayer2];
//
//
//
//
//    CGMutablePathRef path3 = CGPathCreateMutable();
//    CGPathAddArc(path3, NULL, size.width - rightDownCornerRadius, size.height - rightDownCornerRadius, rightDownCornerRadius, M_PI_4, M_PI_2, NO);
//    CGPathMoveToPoint(path3, NULL, size.width - rightDownCornerRadius, size.height);
//    CGPathAddLineToPoint(path3, NULL, leftDownCornerRadius, size.height);
//    CGPathAddArc(path3, NULL, leftDownCornerRadius, size.height - leftDownCornerRadius, leftDownCornerRadius, M_PI_2, M_PI_4 * 3, NO);
//
//    CAShapeLayer *shapeLayer3 = [CAShapeLayer layer];
//    shapeLayer3.frame = self.view.bounds;
//    shapeLayer3.path = path3;
//    shapeLayer3.lineWidth = 10;
//    shapeLayer3.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer3.strokeColor = [UIColor blueColor].CGColor;
//    CGPathRelease(path3);
//
//    [_view.layer addSublayer:shapeLayer3];
//
//
//
//    CGMutablePathRef path4 = CGPathCreateMutable();
//    CGPathAddArc(path4, NULL, leftDownCornerRadius, size.height - leftDownCornerRadius, leftDownCornerRadius, M_PI_4 * 3, M_PI, NO);
//    CGPathMoveToPoint(path4, NULL, 0, size.height - leftDownCornerRadius);
//    CGPathAddLineToPoint(path4, NULL, 0, leftUpCornerRadius);
//    CGPathAddArc(path4, NULL, leftUpCornerRadius, leftUpCornerRadius, leftUpCornerRadius, M_PI, -M_PI_4 * 3, NO);
//
//    CAShapeLayer *shapeLayer4 = [CAShapeLayer layer];
//    shapeLayer4.frame = self.view.bounds;
//    shapeLayer4.path = path4;
//    shapeLayer4.lineWidth = 10;
//    shapeLayer4.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer4.strokeColor = [UIColor grayColor].CGColor;
//    CGPathRelease(path4);
//
//    [_view.layer addSublayer:shapeLayer4];
//
//    return shapeLayer;


- (void)_syncBorderDraw{
    _borderLayer.hidden = true;
    _borderTopLayer.hidden = true;
    _borderBottomLayer.hidden = true;
    _borderLeftLayer.hidden = true;
    _borderRightLayer.hidden = true;
    CGSize size = _view.bounds.size;
    if([self __isSameBorder]){
        if(!_borderLayer){
            _borderLayer = [CAShapeLayer layer];
            [_view.layer addSublayer:_borderLayer];
        }
        _borderLayer.frame = _view.bounds;
        _borderLayer.hidden = false;
        UIBezierPath * path = [UIBezierPath bezierPath];
        CGFloat radius = _borderTopLeftRadius;
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:M_PI * (3/2.0f) clockwise:true];
        radius = _borderTopRightRadius;
        [path addLineToPoint:CGPointMake(size.width - radius, 0)];
        [path addArcWithCenter:CGPointMake(size.width - radius, radius) radius:radius startAngle:M_PI * (3/2.0f) endAngle:2 * M_PI clockwise:true];
        radius = _borderBottomRightRadius;
        [path addLineToPoint:CGPointMake(size.width, size.height - radius)];
        [path addArcWithCenter:CGPointMake(size.width - radius, size.height - radius) radius:radius startAngle:2 * M_PI endAngle:M_PI_2 clockwise:YES];
        radius = _borderBottomLeftRadius;
        [path addLineToPoint:CGPointMake(radius, size.height)];
        [path addArcWithCenter:CGPointMake(radius, size.height - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [path closePath];
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
        _borderLayer.strokeColor = _borderTopColor.CGColor;
        _borderLayer.lineWidth = 2 * _borderTopWidth;
        
        if(_borderTopStyle == VABorderStyleDashed){
             _borderLayer.lineDashPattern = @[@(3 * _borderTopWidth), @(3 * _borderTopWidth)];//画虚线
        }else if(_borderTopStyle == VABorderStyleDotted){
             _borderLayer.lineDashPattern = @[@(_borderTopWidth), @(_borderTopWidth)];//画点
        }else {
            _borderLayer.lineDashPattern = nil;
        }
        _borderLayer.path = path.CGPath;
        
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
            _borderTopLayer.strokeColor = _borderTopColor.CGColor;
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
            _borderBottomLayer.strokeColor = _borderBottomColor.CGColor;
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
            _borderLeftLayer.strokeColor = _borderLeftColor.CGColor;
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
            _borderRightLayer.strokeColor = _borderRightColor.CGColor;
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
    if(_borderTopLayer){
//        _borderTopLayer
        //todo tomqiu
    }
}



@end
