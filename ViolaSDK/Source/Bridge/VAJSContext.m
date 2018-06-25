//
//  VAJSContext.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAJSContext.h"

#import "VAUtil.h"
#import "VADefine.h"
#import "VABridgeCategory.h"

@interface VAJSContext()
@property (nonatomic, strong)  JSContext *jsContext;
@end
@implementation VAJSContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _registerDefaultNativeApi];
    }
    return self;
}

#pragma mark - public

- (void)executeJavascript:(NSString *)script
{
    if ([script isKindOfClass:[NSString class]]) {
        VALogDebug(@"%s,script:%@",__func__,script);
        [self.jsContext evaluateScript:script];
    }
}

- (void)registerCallNativeMethod:(NSString *)method callbackBlock:(VAJSCallNative)callNative{
    VAAssert(method.length && callNative, @"mehod or callNative must not be nil");
    _jsContext[method] = ^ (JSValue *instance, JSValue *tasks){
        NSString *instanceId = [instance toString];
        NSArray *tasksArray = [tasks toArray];
        VALogDebug(@"%s_CallNative:tasks:%@, instanceID:%@",__func__,tasksArray,instanceId);
        callNative(instanceId, tasksArray);
    };
}


- (JSValue *)callJSMethod:(NSString *)method args:(NSArray*)args{
    VALogDebug(@"%s method:%@, args:%@", __func__ , method, args);
    return [[self.jsContext globalObject] invokeMethod:method withArguments:args];
}


#pragma mark - registerDefaultNativeApi

- (void)_registerDefaultNativeApi{
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception){
        context.exception = exception;
        NSString *message = [NSString stringWithFormat:@"[js_error]:%@", exception];
        VALogError(message,nil);
    };
    self.jsContext[@"setTimeout"] = ^(JSValue *function, JSValue *timeout) {
        dispatch_queue_t queue = [VAThreadManager getBridgeQueue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([timeout toDouble] / 1000) * NSEC_PER_SEC)),queue, ^{
            [function callWithArguments:@[]];
        });
    };
    self.jsContext[@"nativeLog"] = ^() {
#if DEBUG
        NSMutableString *string = [NSMutableString string];
        [string appendString:@"jsLog: "];
        NSArray *args = [JSContext currentArguments];
        [args enumerateObjectsUsingBlock:^(JSValue *jsVal, NSUInteger idx, BOOL *stop) {
            [string appendFormat:@"%@ ", jsVal ];
        }];
        VALogDebug(string,nil);
#endif
    };
    
}

#pragma mark - getter

- (JSContext *)jsContext{
    if (!_jsContext) {
        _jsContext = [[JSContext alloc] init];
        _jsContext.name = @"Viola Context";
        _jsContext[@"env"] = [VAUtil getNativeInfo];
    }
    return _jsContext;
}

- (JSValue *)exception{
    return self.jsContext.exception;
}

@end
