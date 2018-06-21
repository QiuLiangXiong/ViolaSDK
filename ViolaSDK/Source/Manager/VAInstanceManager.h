//
//  VAInstanceManager.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ViolaInstance;

@interface VAInstanceManager : NSObject


+ (ViolaInstance *)getInstanceWithID:(NSString *)instanceID;

+ (void)setInstance:(ViolaInstance *)instance forID:(NSString *)instanceID;

+ (void)removeInstanceWithID:(NSString *)instanceID;


@end
