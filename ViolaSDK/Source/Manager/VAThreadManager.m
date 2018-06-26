//
//  VATheadManager.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAThreadManager.h"
#import "VALog.h"
#define VA_BRIDGE_THREAD_NAME @"com.tencent.viola.bridge"
#define VA_COMPONENT_THREAD_NAME @"com.tencent.viola.component"
#import "UIKit/UIKit.h"

@interface VAThreadManager()

@end

@implementation VAThreadManager

/*bridge线程*/
static dispatch_queue_t bridgeQueue = NULL;
+ (dispatch_queue_t)getBridgeQueue{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t queue_attr = dispatch_queue_attr_make_with_qos_class (DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE,0);
        bridgeQueue = dispatch_queue_create([VA_BRIDGE_THREAD_NAME UTF8String], queue_attr);
        dispatch_queue_set_specific(bridgeQueue, &bridgeQueue, (void *)[VA_BRIDGE_THREAD_NAME UTF8String], (dispatch_function_t)CFRelease);
    });
    return bridgeQueue;
}
static dispatch_semaphore_t va_signal;
+ (void)waitUntilViolaIntanceRenderFinish{
    va_signal = dispatch_semaphore_create(0);
    dispatch_semaphore_wait(va_signal, dispatch_time(DISPATCH_TIME_NOW, 2*1000*1000*1000));
}

+ (void)violaIntanceRenderFinish{
    if(va_signal){
        dispatch_semaphore_signal(va_signal);
    }
}

+ (instancetype)getIntance{
    static VAThreadManager * instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [VAThreadManager new];
    });
    return instance;
}

+ (BOOL)isBridgeThread{
    if(dispatch_get_specific(&bridgeQueue)){
        return true;
    }
    return false;
}


/*component线程*/
static dispatch_queue_t componentQueue = NULL;
+ (dispatch_queue_t)getComponentQueue{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t queue_attr = dispatch_queue_attr_make_with_qos_class (DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE,0);
        componentQueue = dispatch_queue_create([VA_COMPONENT_THREAD_NAME UTF8String], queue_attr);
        dispatch_queue_set_specific(componentQueue, &componentQueue, (void *)[VA_COMPONENT_THREAD_NAME UTF8String], (dispatch_function_t)CFRelease);
    });
    return componentQueue;
}

+ (BOOL)isComponentThread{
    if(dispatch_get_specific(&componentQueue)){
        return true;
    }
    return false;
}


/*执行相关*/
+ (void)performOnBridgeThreadWithBlock:(void (^)(void))block{
    [self performOnBridgeThreadWithBlock:block waitUntilDone:false];
}
+ (void)performOnBridgeThreadWithBlock:(void (^)(void))block waitUntilDone:(BOOL)wait{
    [self _performWithBlock:block onQueue:[self getBridgeQueue] isQueueThread:[self isBridgeThread] waitUntilDone:wait];
}

+ (void)performOnComponentThreadWithBlock:(void (^)(void))block{
    [self performOnComponentThreadWithBlock:block waitUntilDone:false];
}
+ (void)performOnComponentThreadWithBlock:(void (^)(void))block waitUntilDone:(BOOL)wait{
    [self _performWithBlock:block onQueue:[self getComponentQueue] isQueueThread:[self isComponentThread] waitUntilDone:wait];
}

+ (void)performOnMainThreadWithBlock:(void (^)(void))block{
    [self performOnMainThreadWithBlock:block waitUntilDone:false];
}


+ (void)performOnComponentThreadWithBlock:(void (^)(void))block afterDelay:(double)second{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((second) * NSEC_PER_SEC)),[self getComponentQueue], ^{
        if (block) {
            block();
        }
    });
}

+ (void)performOnBridgeThreadWithBlock:(void (^)(void))block afterDelay:(double)second{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((second) * NSEC_PER_SEC)),[self getBridgeQueue], ^{
        if (block) {
            block();
        }
    });
}

+ (void)performOnMainThreadWithBlock:(void (^)(void))block waitUntilDone:(BOOL)wait{
    if (!block) {
        return ;
    }
    if ([NSThread isMainThread]) {
        block();
    }else {
        if (wait) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                block();
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }
    }
}

+ (void)_performWithBlock:(void (^)(void))block onQueue:(dispatch_queue_t)queue isQueueThread:(BOOL)isQueueThread waitUntilDone:(BOOL)wait{
    if (block == nil || queue == nil) return;
    if (isQueueThread) {
        block();
    }else {
        if (!wait) {
            dispatch_async(queue, ^{
                block();
            });
        }else {
            dispatch_sync(queue, ^{
                block();
            });
        }
    }
}


@end
