//
//  VAConvertUtl.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VAConvertUtl : NSObject

+ (BOOL)convertToBOOL:(id)value;
+ (CGFloat)convertToFloat:(id)value;
+ (NSInteger)convertToInteger:(id)value;
+ (NSString *)convertToString:(id)value;

@end
