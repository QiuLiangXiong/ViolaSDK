//
//  VAUtil.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAUtil.h"
#import "VADefine.h"

@implementation VAUtil


+ (NSDictionary *)getNativeInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *systermVersion = [[UIDevice currentDevice] systemVersion] ?: @"";
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"] ? : @"1.0.0";
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"] ? : @"";
    ;
    CGFloat devideWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat devideHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"platform":@"iOS",
                                                                                @"osVersion":systermVersion,
                                                                                @"violaVersion":VA_SDK_VERSION,
                                                                                @"appName":appName,
                                                                                @"appVersion":appVersion,
                                                                                @"deviceWidth":@(devideWidth),
                                                                                @"deviceHeight":@(devideHeight),
                                                                                @"scale":@(scale)
                                                                                }];
    return data;
}

@end
