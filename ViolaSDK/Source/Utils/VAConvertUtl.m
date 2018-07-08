//
//  VAConvertUtl.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAConvertUtl.h"
#import "VALog.h"
#import <JavaScriptCore/JavaScriptCore.h>


@implementation VAConvertUtl

+ (CGFloat)convertToFloatWithPixel:(id)value{
    BOOL isDp = NO;
    CGFloat cValue = 0;
    if([value isKindOfClass:[NSString class]] && [value hasSuffix:@"dp"]){
        isDp = YES;
        NSString * valueString = (NSString *)value;
        valueString = [valueString substringToIndex:(valueString.length - 2)];
        cValue = [valueString doubleValue];
    }else if([value isKindOfClass:[NSString class]] && [value hasSuffix:@"px"]){
        NSString * valueString = (NSString *)value;
        valueString = [valueString substringToIndex:(valueString.length - 2)];
        cValue = [valueString doubleValue];
    }else if([value isKindOfClass:[NSString class]]){
        cValue = [(NSString *)value doubleValue];
    }else {
        cValue = [VAConvertUtl convertToFloat:value];
    }
    if(isDp){
        return cValue;
    }else {
        return (cValue / 750.0f) * VAScreenSize().width;
    }
}

+ (CGFloat)convertToFloat:(id)value defaultValue:(CGFloat)defaultValue{
    if(!value){
        return defaultValue;
    }
    return [self convertToFloat:value];
}
+ (CGFloat)convertToFloat:(id)value{
    if (!value) return 0;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *valueString = (NSString *)value;
        if ([valueString hasSuffix:@"px"] || [valueString hasSuffix:@"dp"]) {
            return [self convertToFloatWithPixel:valueString];
        }
        return [valueString doubleValue];
    }else if([value isKindOfClass:[JSValue class]]){
        return (CGFloat)[(JSValue *)value toDouble];
    }else if([value isKindOfClass:[NSObject class]] && [value respondsToSelector:@selector(doubleValue)]){
        return (CGFloat)[value doubleValue];
    }else {
        VALogDebug(@"%s convert fail",__func__);
    }
    return 0;
}

+ (NSString *)convertToString:(id)value defaultValue:(NSString *)defaultValue{
    if(!value){
        return defaultValue;
    }
    return [self convertToString:value];
}

+ (NSString *)convertToString:(id)value{
    if (!value) return nil;
    if([value isKindOfClass:[NSString class]]){
        return value;
    }else if([value isKindOfClass:[JSValue class]]){
        return [(JSValue *)value toString];
    }else if([value isKindOfClass:[NSObject class]] && [value respondsToSelector:@selector(stringValue)]){
        return (NSString *)[value stringValue];
    }else {
        VALogDebug(@"%s convert fail",__func__);
    }
    return nil;
}

+ (BOOL)convertToBOOL:(id)value{
    if([value isKindOfClass:[NSObject class]] && [value respondsToSelector:@selector(boolValue)]){
        return (BOOL)[value boolValue];
    }else if([value isKindOfClass:[JSValue class]]){
        return [(JSValue *)value toBool];
    }else {
        VALogDebug(@"%s_convert fail",__func__);
    }
    return false;
}

+ (NSInteger)convertToInteger:(id)value{
    if ([value isKindOfClass:[NSString class]]) {
        NSString *valueString = (NSString *)value;
        if ([valueString hasSuffix:@"px"] || [valueString hasSuffix:@"dp"]) {
            valueString = [valueString substringToIndex:(valueString.length - 2)];
        }
        return [valueString integerValue];
    }else if([value isKindOfClass:[NSObject class]] && [value respondsToSelector:@selector(integerValue)]){
        return (NSInteger)[value integerValue];
    }else if([value isKindOfClass:[JSValue class]]){
        return (NSInteger)[(JSValue *)value toInt32];
    }else {
        VALogDebug(@"%s_convert fail",__func__);
    }
    return 0;
}

+ (NSMutableDictionary *)convertToMutableDictionary:(NSDictionary *)dictionary{
    if(![dictionary isKindOfClass:[NSDictionary class]]) return [NSMutableDictionary new];
    if([dictionary isKindOfClass:[NSMutableDictionary class]]){
        return (NSMutableDictionary *)dictionary;
    }else {
        return [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
}

+ (NSMutableArray *)convertToMutableArray:(NSArray *)array{
    if(![array isKindOfClass:[NSArray class]]) return [NSMutableArray new];
    if([array isKindOfClass:[NSMutableArray class]]){
        return (NSMutableArray *)array;
    }else {
        return [NSMutableArray arrayWithArray:array];
    }
}


#pragma mark cssNode Layout

+(css_position_type_t)css_position_type_t:(id)value{
    if([value isKindOfClass:[NSString class]]){
        if ([value isEqualToString:@"absolute"]) {
            return CSS_POSITION_ABSOLUTE;
        } else if ([value isEqualToString:@"relative"]) {
            return CSS_POSITION_RELATIVE;
        } else if ([value isEqualToString:@"fixed"]) {
            return CSS_POSITION_ABSOLUTE;
        } else if ([value isEqualToString:@"sticky"]) {
            return CSS_POSITION_RELATIVE;
        }
    }
    return CSS_POSITION_RELATIVE;
}

+ (css_flex_direction_t)css_flex_direction_t:(id)value{
    if([value isKindOfClass:[NSString class]]){
        if ([value isEqualToString:@"column"]) {
            return CSS_FLEX_DIRECTION_COLUMN;
        } else if ([value isEqualToString:@"column-reverse"]) {
            return CSS_FLEX_DIRECTION_COLUMN_REVERSE;
        } else if ([value isEqualToString:@"row"]) {
            return CSS_FLEX_DIRECTION_ROW;
        } else if ([value isEqualToString:@"row-reverse"]) {
            return CSS_FLEX_DIRECTION_ROW_REVERSE;
        }
    }
    return CSS_FLEX_DIRECTION_COLUMN;
}

+ (css_align_t)css_align_t:(id)value{
    if([value isKindOfClass:[NSString class]]){
        if ([value isEqualToString:@"stretch"]) {
            return CSS_ALIGN_STRETCH;
        } else if ([value isEqualToString:@"flex-start"]) {
            return CSS_ALIGN_FLEX_START;
        } else if ([value isEqualToString:@"flex-end"]) {
            return CSS_ALIGN_FLEX_END;
        } else if ([value isEqualToString:@"center"]) {
            return CSS_ALIGN_CENTER;
        } else if ([value isEqualToString:@"auto"]) {
            return CSS_ALIGN_AUTO;
        }
    }
    return CSS_ALIGN_STRETCH;
}

+ (css_wrap_type_t)css_wrap_type_t:(id)value{
    if([value isKindOfClass:[NSString class]]) {
        if ([value isEqualToString:@"nowrap"]) {
            return CSS_NOWRAP;
        } else if ([value isEqualToString:@"wrap"]) {
            return CSS_WRAP;
        }
    }
    
    return CSS_NOWRAP;
}

+ (css_justify_t)css_justify_t:(id)value{
    if([value isKindOfClass:[NSString class]]){
        if ([value isEqualToString:@"flex-start"]) {
            return CSS_JUSTIFY_FLEX_START;
        } else if ([value isEqualToString:@"center"]) {
            return CSS_JUSTIFY_CENTER;
        } else if ([value isEqualToString:@"flex-end"]) {
            return CSS_JUSTIFY_FLEX_END;
        } else if ([value isEqualToString:@"space-between"]) {
            return CSS_JUSTIFY_SPACE_BETWEEN;
        } else if ([value isEqualToString:@"space-around"]) {
            return CSS_JUSTIFY_SPACE_AROUND;
        }
    }
    return CSS_JUSTIFY_FLEX_START;
}



CGFloat VAScreenScale(void)
{
    static CGFloat _scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scale = [UIScreen mainScreen].scale;
    });
    return _scale;
}
CGSize VAScreenSize(void)
{
    static CGSize screenSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        screenSize = [UIScreen mainScreen].bounds.size;
    });
    return screenSize;
}

CGFloat VARoundValue(CGFloat value){
    if(isnan(value)){
        value = 0;
    }
    CGFloat scale = VAScreenScale();
    
    return round(value * scale) / scale;
}
CGFloat VACeilValue(CGFloat value)
{
    CGFloat scale = VAScreenScale();
    return ceil(value * scale) / scale;
}

CGFloat VAFloorValue(CGFloat value)
{
    CGFloat scale = VAScreenScale();
    return floor(value * scale) / scale;
}

#pragma mark - view prop
+ (UIColor *)convertToColor:(id)value defaultValue:(UIColor *)defaultValue{
    if(!value){
        return defaultValue;
    }
    return [self convertToColor:value];
}
+ (UIColor *)convertToColor:(id)value{
    static NSCache *colorCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorCache = [[NSCache alloc] init];
        colorCache.countLimit = 128;
    });
    
    
    if ([value isKindOfClass:[NSNull class]] || !value) {
        return nil;
    }
    
    UIColor *color = [colorCache objectForKey:value];
    if (color) {
        return color;
    }
    double red = 255, green = 255, blue = 255, alpha = 1.0;
    
    if([value isKindOfClass:[NSString class]]){
        static NSDictionary *knownColors;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            knownColors = @{
                            @"black": @"#000000",
                            @"blue": @"#0000ff",
                            @"brown": @"#a52a2a",
                            @"darkgray": @"#a9a9a9",
                            @"cyan": @"#00ffff",
                            @"coral": @"#ff7f50",
                            @"darkgreen": @"#006400",
                            @"darkslategrey": @"#2f4f4f",
                            @"gold": @"#ffd700",
                            @"goldenrod": @"#daa520",
                            @"gray": @"#808080",
                            @"grey": @"#808080",
                            @"green": @"#008000",
                            @"greenyellow": @"#adff2f",
                            @"honeydew": @"#f0fff0",
                            @"lightblue": @"#add8e6",
                            @"lightcoral": @"#f08080",
                            @"lightcyan": @"#e0ffff",
                            @"lightgray": @"#d3d3d3",
                            @"lightgrey": @"#d3d3d3",
                            @"lightgreen": @"#90ee90",
                            @"lightpink": @"#ffb6c1",
                            @"lightskyblue": @"#87cefa",
                            @"lightslategray": @"#778899",
                            @"lightslategrey": @"#778899",
                            @"lightsteelblue": @"#b0c4de",
                            @"lightyellow": @"#ffffe0",
                            @"white": @"#ffffff",
                            @"whitesmoke": @"#f5f5f5",
                            @"yellow": @"#ffff00",
                            @"yellowgreen": @"#9acd32",
                            @"red" : @"#dd4b39",
                            @"transparent": @"rgba(0,0,0,0)",
                            
                            };
        });
        NSString *rgba = knownColors[value];
        if (!rgba) {
            rgba = value;
        }
        
        if ([rgba hasPrefix:@"#"]) {
            // #fff
            if ([rgba length] == 4) {
                unichar f =   [rgba characterAtIndex:1];
                unichar s =   [rgba characterAtIndex:2];
                unichar t =   [rgba characterAtIndex:3];
                rgba = [NSString stringWithFormat:@"#%C%C%C%C%C%C", f, f, s, s, t, t];
            }
            
            // 3. #rrggbb
            uint32_t colorValue = 0;
            sscanf(rgba.UTF8String, "#%x", &colorValue);
            red     = ((colorValue & 0xFF0000) >> 16) / 255.0;
            green   = ((colorValue & 0x00FF00) >> 8) / 255.0;
            blue    = (colorValue & 0x0000FF) / 255.0;
        } else if ([rgba hasPrefix:@"rgb("]) {
            // 4. rgb(r,g,b)
            int r,g,b;
            sscanf(rgba.UTF8String, "rgb(%d,%d,%d)", &r, &g, &b);
            red = r / 255.0;
            green = g / 255.0;
            blue = b / 255.0;
        } else if ([rgba hasPrefix:@"rgba("]) {
            // 5. rgba(r,g,b,a)
            int r,g,b;
            sscanf(rgba.UTF8String, "rgba(%d,%d,%d,%lf)", &r, &g, &b, &alpha);
            red = r / 255.0;
            green = g / 255.0;
            blue = b / 255.0;
        }
        
    } else if([value isKindOfClass:[NSNumber class]]) {
        NSUInteger colorValue = [value unsignedIntegerValue];
        red     = ((colorValue & 0xFF0000) >> 16) / 255.0;
        green   = ((colorValue & 0x00FF00) >> 8) / 255.0;
        blue    = (colorValue & 0x0000FF) / 255.0;
    }
    
    color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    // 6. cache color
    if (color && value) {
        [colorCache setObject:color forKey:value];
    }
    
    return color;
}


+ (BOOL)convertToBOOLWithClipValue:(id)value defaultValue:(BOOL)defaultValue{
    if(!value){
        return defaultValue;
    }
    return [self convertToBOOLWithClipValue:value];
}
+ (BOOL)convertToBOOLWithClipValue:(id)value{
    if([value isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)value;
        if ([string isEqualToString:@"visible"]) {////hidden
            return NO;
        }
        
    }else if([value isKindOfClass:[NSNumber class]]){
        if([value doubleValue] == 0){
            return NO;
        }
    }
    return YES;
}

// visible or hidden
+ (BOOL)convertToBOOLWithVisibilityValue:(id)value defaultValue:(BOOL)defaultValue{
    if(!value){
        return defaultValue;
    }
    return [self convertToBOOLWithVisibilityValue:value];
}
+ (BOOL)convertToBOOLWithVisibilityValue:(id)value{
    if([value isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)value;
        if ([string isEqualToString:@"hidden"]) {
            return NO;
        }
        //visible
    }else if([value isKindOfClass:[NSNumber class]]){
        if([value doubleValue] == 0){
            return NO;
        }
    }
    return YES;
}

+ (VALayoutPosition)converToPosition:(id)value defaultValue:(VALayoutPosition)defaultValue{
    if(!value){
        return defaultValue;
    }
    return [self converToPosition:value];
}

+ (VALayoutPosition)converToPosition:(id)value
{
    if([value isKindOfClass:[NSString class]]){
        if ([value isEqualToString:@"relative"]) {
            return VALayoutPositionRelative;
        } else if ([value isEqualToString:@"absolute"]) {
            return VALayoutPositionAbsolute;
        } else if ([value isEqualToString:@"sticky"]) {
            return VALayoutPositionSticky;
        } else if ([value isEqualToString:@"fixed"]) {
            return VALayoutPositionFixed;
        }
    }
    return VALayoutPositionRelative;
}


+ (VABorderStyle)converToBorderStyle:(id)value{
    if([value isKindOfClass:[NSString class]]){
        if ([value isEqualToString:@"dotted"]) {
            return VABorderStyleDotted;
        } else if ([value isEqualToString:@"dashed"]) {
            return VABorderStyleDashed;
        }
    }
    
    return VABorderStyleSolid;
}


#define VA_TEXT_WEIGHT_RETURN(key,value0,value1)\
if([string isEqualToString:@#key]){\
   if (@available(iOS 8.2, *)) {\
        return value1;\
   }else {\
     return value0;\
   }\
}

+ (CGFloat)converToTextWeight:(id)value{
    NSString *string = [[self class] convertToString:value];
    
    VA_TEXT_WEIGHT_RETURN(normal, 0, UIFontWeightRegular);
    VA_TEXT_WEIGHT_RETURN(bold, 0.4, UIFontWeightBold);
    VA_TEXT_WEIGHT_RETURN(100, -0.8, UIFontWeightUltraLight);
    VA_TEXT_WEIGHT_RETURN(200, -0.6, UIFontWeightThin);
    VA_TEXT_WEIGHT_RETURN(300, -0.4, UIFontWeightLight);
    VA_TEXT_WEIGHT_RETURN(400, 0, UIFontWeightRegular);
    VA_TEXT_WEIGHT_RETURN(500, 0.23, UIFontWeightMedium);
    VA_TEXT_WEIGHT_RETURN(600, 0.3, UIFontWeightSemibold);
    VA_TEXT_WEIGHT_RETURN(700, 0.4, UIFontWeightBold);
    VA_TEXT_WEIGHT_RETURN(800, 0.56, UIFontWeightHeavy);
    VA_TEXT_WEIGHT_RETURN(900, 0.62, UIFontWeightBlack);
    
    if(@available(iOS 8.2, *)){
        return UIFontWeightRegular;
    }else {
        return 0;
    }
}

+ (VATextStyle)convertToTextStyle:(id)value{
    if([value isKindOfClass:[NSString class]]){
        NSString *string = [[self class] convertToString:value];
        if ([string isEqualToString:@"normal"])
        return VATextStyleNormal;
        else if ([string isEqualToString:@"italic"])
        return VATextStyleItalic;
    }
    return VATextStyleNormal;
}

+ (NSTextAlignment)convertToTextAlignment:(id)value{
    NSString *string = [[self class] convertToString:value];
    if ([string isEqualToString:@"left"])     return NSTextAlignmentLeft;

    else if ([string isEqualToString:@"center"])     return NSTextAlignmentCenter;

    else if ([string isEqualToString:@"right"])     return NSTextAlignmentRight;

    return NSTextAlignmentLeft;
}


+ (VATextDecoration)convertToTextDecoration:(id)value{
    NSString *string = [[self class] convertToString:value];
    if ([string isEqualToString:@"underline"]) return VATextDecorationUnderline;
    else if ([string isEqualToString:@"line-through"])    return VATextDecorationLineThrough;
    return VATextDecorationNone;
}

+ (NSLineBreakMode)convertToTextOverflow:(id)value{
    NSString *string = [[self class] convertToString:value];
    if ([string isEqualToString:@"ellipsis"]) return NSLineBreakByTruncatingTail;
    else if ([string isEqualToString:@"clip"])    return NSLineBreakByClipping;
    else if ([string isEqualToString:@"ellipsis-middel"])    return NSLineBreakByTruncatingMiddle;
    else if ([string isEqualToString:@"ellipsis-head"])    return NSLineBreakByTruncatingHead;
    return NSLineBreakByTruncatingTail;
}

#define VA_EDGE_VALUE(str)\
([[self class] convertToFloatWithPixel:str])

+ (UIEdgeInsets)converToEdgeInsets:(id)value{
    NSString *string = [[self class] convertToString:value];
    if(string.length < 5) return UIEdgeInsetsZero;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(string.length < 5) return UIEdgeInsetsZero;
    if ([string rangeOfString:@"{"].length || [string rangeOfString:@"("].length) {
       string = [string substringWithRange:NSMakeRange(1, string.length- 2)];
    }
    NSArray * nums = [string componentsSeparatedByString:@","];
    if (nums.count < 4) return UIEdgeInsetsZero;
    
    return UIEdgeInsetsMake(VA_EDGE_VALUE(nums[0]), VA_EDGE_VALUE(nums[1]), VA_EDGE_VALUE(nums[2]), VA_EDGE_VALUE(nums[3]));
}

+ (UIViewContentMode)converToContentMode:(id)value{
    NSString *string = [[self class] convertToString:value];
    if ([string isEqualToString:@"cover"])
        return UIViewContentModeScaleAspectFill;
    else if ([string isEqualToString:@"contain"])
        return UIViewContentModeScaleAspectFit;
    else if ([string isEqualToString:@"stretch"])
        return UIViewContentModeScaleToFill;
    return UIViewContentModeScaleToFill;
}

+ (NSMutableDictionary *)convertToDictionaryWithSize:(CGSize)size{
    NSMutableDictionary * res = [NSMutableDictionary new];
    res[@"width"] = [NSString stringWithFormat:@"%.2lfdp",size.width];
    res[@"height"] = [NSString stringWithFormat:@"%.2lfdp",size.height];
    return res;
}
+ (NSMutableDictionary *)convertToDictionaryWithPoint:(CGPoint)point{
    NSMutableDictionary * res = [NSMutableDictionary new];
    res[@"x"] = [NSString stringWithFormat:@"%.2lfdp",point.x];
    res[@"y"] = [NSString stringWithFormat:@"%.2lfdp",point.y];
    return res;
}
+ (NSMutableDictionary *)convertToDictionaryWithRect:(CGRect)rect{
    NSMutableDictionary * res = [NSMutableDictionary new];
    res[@"x"] = [NSString stringWithFormat:@"%.2lfdp",rect.origin.x];
    res[@"y"] = [NSString stringWithFormat:@"%.2lfdp",rect.origin.y];
    res[@"width"] = [NSString stringWithFormat:@"%.2lfdp", rect.size.width];
    res[@"height"] = [NSString stringWithFormat:@"%.2lfdp",rect.size.height];
    return res;
}

+ (VATransform *)converToTransform:(id)transform origin:(id)origin{
    if (transform || origin) {
        NSString * transformStr = [VAConvertUtl convertToString:transform];
        NSString * originStr = [VAConvertUtl convertToString:origin];
        if (transformStr.length || originStr.length) {
            return [[VATransform alloc] initWithCSSTransform:transformStr cssOrigin:originStr];
        }
    }
    return nil;
}

//convertToTextDecoration
@end
