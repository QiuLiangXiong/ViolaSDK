//
//  VAValue.h
//  ViolaSDK
//
//  Created by QLX on 2018/7/8.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, VAValueType) {
    VAValueNoneType,//
    VAValueFloatType,//
    VAValuePercentageType,//百分比
    VAValueAngleType,//角度
};

@interface VAValue : NSObject

@property(nonatomic, assign , readonly) VAValueType valueType;

+ (VAValue *)valueWithString:(NSString *)value isPixel:(BOOL)pixel;
- (CGFloat)percentageValueWithLength:(CGFloat)length;
- (CGFloat)floatValueWithLength:(CGFloat)length;
- (CGFloat)floatValue;
- (CGFloat)angleValue;


@end
NS_ASSUME_NONNULL_END
