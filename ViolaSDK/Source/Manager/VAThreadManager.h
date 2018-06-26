//
//  VATheadManager.h
//  Viola相关线程管理中心
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VAThreadManager : NSObject

+ (dispatch_queue_t)getBridgeQueue;
+ (dispatch_queue_t)getComponentQueue;
//是否为bridge线程
+ (BOOL)isBridgeThread;
+ (void)performOnBridgeThreadWithBlock:(void (^)(void))block;
+ (void)performOnBridgeThreadWithBlock:(void (^)(void))block waitUntilDone:(BOOL)wait;
+ (void)performOnBridgeThreadWithBlock:(void (^)(void))block afterDelay:(double)second;
//是否为component线程
+ (BOOL)isComponentThread;
+ (void)performOnComponentThreadWithBlock:(void (^)(void))block;
+ (void)performOnComponentThreadWithBlock:(void (^)(void))block waitUntilDone:(BOOL)wait;
+ (void)performOnComponentThreadWithBlock:(void (^)(void))block afterDelay:(double)second;


+ (void)performOnMainThreadWithBlock:(void (^)(void))block;
+ (void)performOnMainThreadWithBlock:(void (^)(void))block waitUntilDone:(BOOL)wait;

+ (void)waitUntilViolaIntanceRenderFinish;
+ (void)violaIntanceRenderFinish;


@end
