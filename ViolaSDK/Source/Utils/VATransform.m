//
//  VATransform.m
//  ViolaSDK
//
//  Created by QLX on 2018/7/8.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VATransform.h"
#import "UIKit/UIKit.h"
#import "VAConvertUtl.h"
#import "VAValue.h"

#define VALengthFlag 10000000

@implementation VATransform{
    VAValue * _translationX;
    VAValue * _translationY;
    VAValue * _scaleX;
    VAValue * _scaleY;
    VAValue * _rotate;
    
    VAValue * _originX;
    VAValue * _originY;
}

- (instancetype)initWithCSSTransform:(NSString *)transform cssOrigin:(NSString *)origin{
    if (self = [super init]) {
        [self _parseTransform:transform];
        [self _parseTransformOrigin:origin];
    }
    return self;
}

#pragma mark - public


- (void)transformToView:(UIView *)view{
    if (!view || CGSizeEqualToSize(view.frame.size, CGSizeZero)) return ;
    [self _transformOriginToView:view];
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGSize size = view.bounds.size;
    if (_translationX || _translationY) {
        transform = CGAffineTransformTranslate(transform, _translationX ? [_translationX floatValueWithLength:size.width]:0,_translationY ? [_translationY floatValueWithLength:size.height] : 0);
    }
    if (_scaleX || _scaleY) {
         transform = CGAffineTransformScale(transform, _scaleX ? [_scaleX percentageValueWithLength:1.0f]:1.0,_scaleY ? [_scaleY percentageValueWithLength:1.0f] : 1.0);
    }
    if (_rotate) {
        transform = CGAffineTransformRotate(transform, [_rotate angleValue]);
    }
    if (!CGAffineTransformEqualToTransform(transform, view.transform)) {
        view.transform = transform;
    }
}


#pragma mark - private parse

- (void)_transformOriginToView:(UIView *)view{
    
    if (_originX || _originY) {
        CGPoint viewAnchorPoint = view.layer.anchorPoint;
        CGSize size = view.bounds.size;
        CGFloat archorPointX = _originX ? [_originX percentageValueWithLength:size.width] : 0.5;
        CGFloat archorPointY = _originY ? [_originY percentageValueWithLength:size.height] : 0.5;
        
        if (viewAnchorPoint.x != archorPointX || viewAnchorPoint.y != archorPointY) {
            CGPoint newPoint = CGPointMake(size.width * archorPointX, size.height * archorPointY);
            CGPoint oldPoint = CGPointMake(size.width * viewAnchorPoint.x,size.height * viewAnchorPoint.y);
            newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
            oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
            CGPoint position = view.layer.position;
            position.x += (newPoint.x - oldPoint.x);
            position.y += (newPoint.y - oldPoint.y);
            view.layer.position = position;
            view.layer.anchorPoint = CGPointMake(archorPointX, archorPointY);
        }
    }
}

- (void)_parseTransformOrigin:(NSString *)origin{
    if ([origin isKindOfClass:[NSString class]] && origin.length && ![origin isEqualToString:@"none"]) {
        NSArray * components = [origin componentsSeparatedByString:@" "];
        NSString * originX = components.firstObject ? : nil;
        NSString * originY = components.count > 1 ? components.lastObject: nil;
        //left center right
        if ([originX isEqualToString:@"left"]) {
            _originX = [VAValue valueWithString:@"0%" isPixel:false];
        }else if([originX isEqualToString:@"right"]){
            _originX = [VAValue valueWithString:@"100%" isPixel:false];
        }else if([originX isEqualToString:@"center"]){
            _originX = [VAValue valueWithString:@"50%" isPixel:false];
        }else if(originX.length){
            _originX = [VAValue valueWithString:originX isPixel:true];
        }
        if ([originY isEqualToString:@"top"]) {
            _originY = [VAValue valueWithString:@"0%" isPixel:false];
        }else if([originY isEqualToString:@"bottom"]){
            _originY = [VAValue valueWithString:@"100%" isPixel:false];
        }else if([originY isEqualToString:@"center"]){
            _originY = [VAValue valueWithString:@"50%" isPixel:false];
        }else if(originY.length){
            _originY = [VAValue valueWithString:originY isPixel:true];
        }
    }
}

- (void)_parseTransform:(NSString *)transform{
    if ([transform isKindOfClass:[NSString class]] && transform.length && ![transform isEqualToString:@"none"]) {
         NSArray * components = [transform componentsSeparatedByString:@" "];
        for (NSString * sub in components) {
            NSString * component = [sub stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (!component.length) continue;
            if ([component hasPrefix:@"translateX("] && [component hasSuffix:@")"]) {
                _translationX = [self __getValueWithPrefix:@"translateX(" component:component originValue:_translationX ];
            }else if ([component hasPrefix:@"translateY("] && [component hasSuffix:@")"]) {
                _translationY = [self __getValueWithPrefix:@"translateY(" component:component originValue:_translationY ];
            }else if ([component hasPrefix:@"translate("] && [component hasSuffix:@")"]) {
                NSArray * components = [component componentsSeparatedByString:@","];
                if (components.count == 1) {
                    _translationX = [self __getValueWithPrefix:@"translate(" component:component originValue:_translationX];
                }else if(components.count == 2){
                    NSString * firstComponent = [components.firstObject stringByAppendingString:@")"];
                    _translationX = [self __getValueWithPrefix:@"translate(" component:firstComponent originValue:_translationX];
                    NSString * secondComponent = [@"translate(" stringByAppendingString:components.lastObject];
                    _translationY = [self __getValueWithPrefix:@"translate(" component:secondComponent originValue:_translationY];
                }
                
            }else if ([component hasPrefix:@"scaleX("] && [component hasSuffix:@")"]) {
                _scaleX = [self __getValueWithPrefix:@"scaleX(" component:component originValue:_scaleX];
            }else if ([component hasPrefix:@"scaleY("] && [component hasSuffix:@")"]) {
                _scaleY = [self __getValueWithPrefix:@"scaleY(" component:component originValue:_scaleY];
            }else if ([component hasPrefix:@"scale("] && [component hasSuffix:@")"]) {
                NSArray * components = [component componentsSeparatedByString:@","];
                if (components.count == 1) {
                    _scaleX = [self __getValueWithPrefix:@"scale(" component:component originValue:_scaleX];
                }else if(components.count == 2){
                    NSString * firstComponent = [components.firstObject stringByAppendingString:@")"];
                    _scaleX = [self __getValueWithPrefix:@"scale(" component:firstComponent originValue:_scaleX];
                    NSString * secondComponent = [@"scale(" stringByAppendingString:components.lastObject];
                    _scaleY = [self __getValueWithPrefix:@"scale(" component:secondComponent originValue:_scaleY];
                }
            }else if ([component hasPrefix:@"rotate("] && [component hasSuffix:@")"]) {
                _rotate = [self __getValueWithPrefix:@"rotate(" component:component originValue:_rotate];
            }
        }
    }
}

- (VAValue *)__getValueWithPrefix:(NSString *)prefix component:(NSString *)component originValue:(VAValue *)originValue {
    BOOL isRotate = [prefix hasPrefix:@"rotate"];
    BOOL isScale = [prefix hasPrefix:@"scale"];
    BOOL isTranslate = [prefix hasPrefix:@"translate"];
    NSUInteger prefixLength = prefix.length;
    if (prefixLength  + 1 > component.length ) {
        return  nil;
    }
    NSString * value = [component substringWithRange:NSMakeRange(prefixLength, component.length - prefixLength - 1)];
    if (isScale) {
        if (value.length) {
            return [VAValue valueWithString:value isPixel:false];
        }
    }else if (isRotate) {
        return [VAValue valueWithString:value isPixel:false];
    }
    else if (isTranslate) {
        if (value.length) {
            return [VAValue valueWithString:value isPixel:true];
        }
    }
    return originValue;
}


@end
