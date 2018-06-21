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

@implementation VAThreadManager

/*bridge线程*/

+ (dispatch_queue_t)getBridgeQueue{
    static dispatch_queue_t bridgeQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t queue_attr = dispatch_queue_attr_make_with_qos_class (DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE,0);
        bridgeQueue = dispatch_queue_create([VA_BRIDGE_THREAD_NAME UTF8String], queue_attr);
    });
    return bridgeQueue;
}


+ (BOOL)isBridgeThread{
    static NSThread * birdgeThread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async([self getBridgeQueue], ^{
            birdgeThread = [NSThread currentThread];
            [[NSRunLoop currentRunLoop] run];
        });
        dispatch_sync([self getBridgeQueue], ^{
        });
    });
    return [NSThread currentThread] == birdgeThread;
}

/*component线程*/
+ (dispatch_queue_t)getComponentQueue{
    static dispatch_queue_t componentQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t queue_attr = dispatch_queue_attr_make_with_qos_class (DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE,0);
        componentQueue = dispatch_queue_create([VA_COMPONENT_THREAD_NAME UTF8String], queue_attr);
    });
    return componentQueue;
}

+ (BOOL)isComponentThread{
    static NSThread * componentThread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async([self getComponentQueue], ^{
            componentThread = [NSThread currentThread];
            [[NSRunLoop currentRunLoop] run];
        });
        dispatch_sync([self getComponentQueue], ^{
        });
    });
    return [NSThread currentThread] == componentThread;
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
