//
//  VAValue.m
//  ViolaSDK
//
//  Created by QLX on 2018/7/8.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAValue.h"
#import "VAConvertUtl.h"
@interface VAValue()
@property(nonatomic, assign , readwrite) VAValueType valueType;

@end
@implementation VAValue{
   CGFloat _floatValue;
}

+ (VAValue *)valueWithString:(NSString *)value isPixel:(BOOL)pixel{
    VAValue * newValue = [VAValue new];
    [newValue _parseWithString:value isPixel:pixel];
    return newValue;
}
- (CGFloat)percentageValueWithLength:(CGFloat)length{
    if (_valueType == VAValuePercentageType) {
        return _floatValue;
    }else if(_valueType == VAValueFloatType){
        return _floatValue / length;
    }
    return 0;
}
- (CGFloat)floatValueWithLength:(CGFloat)length{
    if (_valueType == VAValuePercentageType) {
        return _floatValue * length;
    }else if(_valueType == VAValueFloatType){
        return _floatValue;
    }
    return 0;
}
- (CGFloat)floatValue{
    if (_valueType == VAValueFloatType) {
        return _floatValue;
    }
    return 0;
}
- (CGFloat)angleValue{
    if (_valueType == VAValueAngleType) {
        return _floatValue;
    }
    return 0;
}
#pragma mark - private

- (void)_parseWithString:(NSString *)value isPixel:(BOOL)pixel{
    value = [VAConvertUtl convertToString:value];
    if([value hasSuffix:@"%"]){
        value = [value substringToIndex:value.length - 1];
        _floatValue = [value doubleValue] / 100.0f;
        _valueType = VAValuePercentageType;
    }else if([value hasSuffix:@"deg"]){
        value = [value substringToIndex:value.length - 3];
        _valueType = VAValueAngleType;
        _floatValue = ([VAConvertUtl convertToFloat:value] / 360.0f) * (M_PI * 2);
    }else if(pixel){
        _valueType = VAValueFloatType;
        _floatValue = [VAConvertUtl convertToFloatWithPixel:value];
    }else if(!pixel){
        _valueType = VAValueFloatType;
        _floatValue = [VAConvertUtl convertToFloat:value];
    }
}

@end
