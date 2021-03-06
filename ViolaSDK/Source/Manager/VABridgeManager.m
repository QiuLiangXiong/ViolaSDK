//
//  VABridgeManager.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VABridgeManager.h"
#import "VAThreadManager.h"
#import "VAJSBridge.h"
#import "VADefine.h"
#import "VAInstanceManager.h"
@interface VABridgeManager()

@property (nullable, nonatomic, strong) VAJSBridge * jsBridge;

@end
@implementation VABridgeManager

+ (instancetype)shareManager{
    static VABridgeManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VABridgeManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _jsBridge = [[VAJSBridge alloc] init];
    }
    return self;
}


- (void)executeJSScript:(NSString *)script{
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [self.jsBridge executeJSScript:script];
    }];
}

- (void)callJSMethod:(VAJSMethod *)jsMethod{
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [self.jsBridge callJSMethod:jsMethod];
    }];
}

- (void)createInstanceWithID:(NSString *)instanceID
                      script:(NSString *)script
                        data:(NSDictionary *)data{
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [self.jsBridge createInstanceWithID:instanceID script:script data:data];
    }];
}

- (void)destroyInstanceWithID:(NSString *)instanceID{
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [self.jsBridge  destroyInstanceWithID:instanceID];
    }];
}

- (void)updateInstance:(NSString *)instance
                 param:(NSDictionary *)param{
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [self.jsBridge  updateInstance:instance param:param];
    }];
}

- (void)registerModuleWithName:(NSString *)name methods:(NSArray *)methods{
    if (methods.count == 0) {
        return ;
    }
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        if ([name isEqualToString:@"dom"]) {
            return ;//js那边不需要dom的注册
        }
        [self.jsBridge  registerModuleWithName:name methods:methods];
    }];
}
- (void)registerComponentWithName:(NSString *)name methods:(NSArray *)methods{
    if (methods.count == 0) {
        return ;
    }
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [self.jsBridge  registerComponentWithName:name methods:methods];
    }];
}

- (void)fireEventWithIntanceID:(NSString *)instanceId ref:(NSString *)ref type:(NSString *)type params:(NSDictionary *)params domChanges:(NSDictionary *)domChanges{
    VAAssertReturn(ref && type, @"can't be nil");
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        NSArray *args = @[ref, type];
        
        ViolaInstance * instance = [VAInstanceManager getInstanceWithID:instanceId];
        VAJSMethod * method = [[VAJSMethod alloc] initWithModuleName:@"dom" methodName:@"fireEvent" arguments:args instance:instance];
        method.data = params;
        [self callJSMethod:method];
    }];
}


- (void)callJSCallback:(NSString *)instanceId func:(NSString *)funcId data:(id)data{
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        NSArray *args = @[[funcId copy]];;
        ViolaInstance * instance = [VAInstanceManager getInstanceWithID:instanceId];
        VAJSMethod * method = [[VAJSMethod alloc] initWithModuleName:@"jsBridge" methodName:@"callback" arguments:args instance:instance];
        method.data = data;
        [self callJSMethod:method];
    }];
   
}

@end
