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

+ (CGFloat)convertToFloat:(id)value{
    if (!value) return 0;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *valueString = (NSString *)value;
        if ([valueString hasSuffix:@"px"] || [valueString hasSuffix:@"dp"]) {
            valueString = [valueString substringToIndex:(valueString.length - 2)];
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



@end
