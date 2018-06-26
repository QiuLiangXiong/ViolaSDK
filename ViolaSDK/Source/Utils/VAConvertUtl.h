//
//  VAConvertUtl.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Layout.h"

typedef NS_ENUM(NSInteger, VALayoutPosition) {
    VALayoutPositionRelative,
    VALayoutPositionAbsolute,
    VALayoutPositionSticky,
    VALayoutPositionFixed
};

typedef NS_ENUM(NSInteger, VABorderStyle) {
    VABorderStyleNone = 0,
    VABorderStyleDotted,
    VABorderStyleDashed,
    VABorderStyleSolid
};

@interface VAConvertUtl : NSObject

+ (CGFloat)convertToFloatWithPixel:(id)value;

+ (BOOL)convertToBOOL:(id)value;
+ (CGFloat)convertToFloat:(id)value;
+ (CGFloat)convertToFloat:(id)value defaultValue:(CGFloat)defaultValue;
+ (NSInteger)convertToInteger:(id)value;
+ (NSString *)convertToString:(id)value;
+ (NSString *)convertToString:(id)value defaultValue:(NSString *)defaultValue;

+ (NSMutableDictionary *)convertToMutableDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)convertToMutableArray:(NSArray *)array;


// cssNode layout

+(css_position_type_t)css_position_type_t:(id)value;
+ (css_flex_direction_t)css_flex_direction_t:(id)value;
+ (css_align_t)css_align_t:(id)value;
+ (css_wrap_type_t)css_wrap_type_t:(id)value;
+ (css_justify_t)css_justify_t:(id)value;

CGFloat VAScreenScale(void);
CGSize VAScreenSize(void);
CGFloat VARoundValue(CGFloat value);
CGFloat VACeilValue(CGFloat value);
CGFloat VAFloorValue(CGFloat value);

+ (UIColor *)convertToColor:(id)value;
+ (UIColor *)convertToColor:(id)value defaultValue:(UIColor *)defaultValue;
+ (BOOL)convertToBOOLWithVisibilityValue:(id)value defaultValue:(BOOL)defaultValue;
+ (BOOL)convertToBOOLWithVisibilityValue:(id)value;
+ (BOOL)convertToBOOLWithClipValue:(id)value defaultValue:(BOOL)defaultValue;
+ (BOOL)convertToBOOLWithClipValue:(id)value;
+ (VALayoutPosition)converToPosition:(id)value defaultValue:(VALayoutPosition)defaultValue;
+ (VALayoutPosition)converToPosition:(id)value;
@end

