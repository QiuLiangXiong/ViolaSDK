//
//  ViolaEngine.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "ViolaEngine.h"
#import "VARegisterManager.h"
#import "VADomModule.h"
#import "VADivComponent.h"
#import "VABridgeManager.h"
#import "VAImageHandlerProtocol.h"

@implementation ViolaEngine


+ (void)startEngineIfNeed{
    [self startEngine:@""];//tomqiu todo
}
/**
 *  启动引擎 with JSFramework script
 **/
+ (void)startEngine:(NSString *)script{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _registerDefaults];
        NSString *filePath = [[NSBundle bundleForClass:self] pathForResource:@"viola_main" ofType:@"js"];
        NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [[VABridgeManager shareManager] executeJSScript:script];
    });
}

+ (void)registerModule:(NSString *)name withClass:(Class)aClass{
    [VARegisterManager registerModuleWithName:name moduleCalss:aClass];
}
+ (void)registerComponent:(NSString *)name withClass:(Class)aClass{
    [VARegisterManager registerComponentWithName:name componentCalss:aClass];
}

+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol{
    [VARegisterManager registerHandler:handler protocol:protocol];
}


+ (void)_registerDefaults{
    //module
    [self registerModule:@"dom" withClass:[VADomModule class]];    //dom
    
    if (NSClassFromString(@"VAHttpModule")) {
    [self registerModule:@"http" withClass:NSClassFromString(@"VAHttpModule")];    //dom
    }
    //component
    
    [self registerComponent:@"div" withClass:[VADivComponent class]];
    [self registerComponent:@"text" withClass:NSClassFromString(@"VATextComponent")];
    [self registerComponent:@"image" withClass:NSClassFromString(@"VAImageComponent")];
    
    //scroller
    [self registerComponent:@"scroller" withClass:NSClassFromString(@"VAScrollerComponent")];
    [self registerComponent:@"list" withClass:NSClassFromString(@"VAListComponent")];
    [self registerComponent:@"refresh" withClass:NSClassFromString(@"VARefreshComponent")];
    
    //handler
    
    if(NSClassFromString(@"VAImageHandler")){//可选
        [self registerHandler:[NSClassFromString(@"VAImageHandler") new] withProtocol:@protocol(VAImageHandlerProtocol)];
    }
    
}




@end
