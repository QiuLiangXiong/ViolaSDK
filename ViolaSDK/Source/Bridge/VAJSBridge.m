//
//  VAJSBridge.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAJSBridge.h"
#import "VAThreadManager.h"
#import "VADefine.h"
#import "VAJSContext.h"
#import "VAInstanceManager.h"
#import "ViolaInstance.h"
#import "VAConvertUtl.h"

#define VA_BRIDGE_REGISTER_MODULE @"registerModules"


@interface VAJSBridge()

@property (nullable, nonatomic, strong) VAJSContext * jsContext;
@property (nonatomic, assign) BOOL executeJSScripted;
@property (nullable, nonatomic, strong) NSMutableArray * jsMethodQueue;

@end

@implementation VAJSBridge

- (instancetype)init
{
    self = [super init];
    if (self) {
        _jsMethodQueue = [NSMutableArray new];
    }
    return self;
}


- (void)executeJSScript:(NSString *)script{
     VAAssertBridgeThread();
     VAAssert(script,@"can't be nil");
    [self.jsContext executeJavascript:script];

    if (self.jsContext.exception) {
    //   NSString * errorInfo = [NSString stringWithFormat:@"script error: %@", self.jsContext.exception];
        VALogError(@"script error: %@",self.jsContext.exception);

    //   VAAssert(!self.jsContext.exception, errorInfo);
    }else {
        self.executeJSScripted = YES;
        [self _performJSMethodQueueTaskIfNeed];
    }

}

- (void)callJSMethod:(VAJSMethod *)jsMethod{
    VAAssertBridgeThread();
    if (jsMethod.instance) {
        [self _callJSMethod:@"callJS" args:@[jsMethod.instance.instanceId , @[[jsMethod callJSTask]]]];
    }
}



- (void)createInstanceWithID:(NSString *)instanceID
                      script:(NSString *)script
                        data:(NSDictionary *)data{
    VAAssertBridgeThread();
    VAAssertReturn(instanceID && script , @"can't be nil");
    
    NSArray *args = @[instanceID, script, data ?: @{}];
    [self _callJSMethod:@"createInstance" args:args];
}

- (void)destroyInstanceWithID:(NSString *)instanceID{
    VAAssertBridgeThread();
    VAAssertReturn(instanceID, @"can't be nil");
    
    [self _callJSMethod:@"destroyInstance" args:@[instanceID]];
}

- (void)updateInstance:(NSString *)instance
                 param:(NSDictionary *)param{
    VAAssertBridgeThread();
    VAAssertReturn(instance, @"can't be nil");
    [self _callJSMethod:@"updateInstance" args:@[instance,param ? : @{}]];
}

#pragma mark - private methods

- (void)_registerBridge{
    VAAssertBridgeThread();
    __weak typeof(self) weakSelf = self;
    [self.jsContext registerCallNativeMethod:@"callNative" callbackBlock:^(NSString *instanceID, NSArray *tasks) {
        [weakSelf _handleCallNativeCallbackWithID:instanceID tasks:tasks];
    }];
}

- (void)_callJSMethod:(NSString *)method args:(NSArray *)args{
    VAAssertBridgeThread();
    if (self.executeJSScripted) {
        [self.jsContext callJSMethod:method args:args];
    }else {
        [self.jsMethodQueue addObject:@{@"method":method ? : @"",@"args":args ? : @[]}];
    }
}

- (void)_performJSMethodQueueTaskIfNeed{
    VAAssertBridgeThread();
    if (self.executeJSScripted && self.jsMethodQueue.count) {
        for (NSDictionary * task in self.jsMethodQueue) {
            NSString * method = task[@"method"];
            NSArray * args = task[@"args"];
            [self _callJSMethod:method args:args];
        }
        [self.jsMethodQueue removeAllObjects];
    }
}

- (void)_handleCallNativeCallbackWithID:(NSString *)instanceID tasks:(NSArray *)tasks{
    VAAssertBridgeThread();
    VAAssertReturn(instanceID && [tasks isKindOfClass:[NSArray class]],@"can't be nil");
    
    
    ViolaInstance *instance = [VAInstanceManager getInstanceWithID:instanceID];
    VAAssertReturn(instance,@"can't be nil");
    
    for(NSDictionary * task in tasks){
        if ([task isKindOfClass:[NSDictionary class]]) {
            NSString *methodName = [VAConvertUtl convertToString:task[@"method"]];
            NSArray *args = task[@"args"] ;
            args = [args isKindOfClass: [NSArray class]] ? args : @[args];
            
            NSString * moduleName =  [VAConvertUtl convertToString:task[@"module"]];
            NSString * componentRef = [VAConvertUtl convertToString:task[@"component"]];
            if ([moduleName isKindOfClass:[NSString class]] && moduleName.length) {
                VAModuleMethod * moduleMethod = [[VAModuleMethod alloc] initWithModuleName:moduleName methodName:methodName arguments:args instance:instance];
                [moduleMethod invoke];
            }else if([componentRef isKindOfClass:[NSString class]] && componentRef.length){
                VAComponentMethod * componentMethod = [[VAComponentMethod alloc] initWithComponentRef:componentRef methodName:methodName arguments:args instance:instance];
                [componentMethod invoke];
            }
        }
    }
}


#pragma mark - getter

- (VAJSContext *)jsContext{
    if (!_jsContext) {
        _jsContext = [[VAJSContext alloc] init];
        [self _registerBridge];
    }
    return _jsContext;
}

@end

