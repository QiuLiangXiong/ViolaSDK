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
    kBlockWeakSelf;
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [weakSelf.jsBridge executeJSScript:script];
    }];
}

- (void)callJSMethod:(VAJSMethod *)jsMethod{
    kBlockWeakSelf;
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [weakSelf.jsBridge callJSMethod:jsMethod];
    }];
}

- (void)createInstanceWithID:(NSString *)instanceID
                      script:(NSString *)script
                        data:(NSDictionary *)data{
    kBlockWeakSelf;
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [weakSelf.jsBridge createInstanceWithID:instanceID script:script data:data];
    }];
}

- (void)destroyInstanceWithID:(NSString *)instanceID{
    kBlockWeakSelf;
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [weakSelf.jsBridge  destroyInstanceWithID:instanceID];
    }];
}

- (void)updateInstance:(NSString *)instance
                 param:(NSDictionary *)param{
    kBlockWeakSelf;
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [weakSelf.jsBridge  updateInstance:instance param:param];
    }];
}

- (void)fireEventWithIntanceID:(NSString *)instanceId ref:(NSString *)ref type:(NSString *)type params:(NSDictionary *)params domChanges:(NSDictionary *)domChanges{
    VAAssertReturn(ref && type, @"can't be nil");
    NSArray *args = @[ref, type, params?:@{}, domChanges?:@{}];
    ViolaInstance * instance = [VAInstanceManager getInstanceWithID:instanceId];
    VAJSMethod * method = [[VAJSMethod alloc] initWithModuleName:nil methodName:@"fireEvent" arguments:args instance:instance];
    [self callJSMethod:method];
}


- (void)callJSCallback:(NSString *)instanceId func:(NSString *)funcId data:(id)data{
    NSArray *args = nil;
    if (data) {
       args = @[[funcId copy], data];
    }else {
       args = @[[funcId copy]];
    }
    ViolaInstance * instance = [VAInstanceManager getInstanceWithID:instanceId];
    VAJSMethod * method = [[VAJSMethod alloc] initWithModuleName:@"jsBridge" methodName:@"callback" arguments:args instance:instance];
    [self callJSMethod:method];
}

@end
