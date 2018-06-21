//
//  ViolaInstance.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "ViolaInstance.h"
#import "VAModuleProtocol.h"
#import "VAInstanceManager.h"
#import "VAThreadManager.h"
#import "VAComponentController.h"
#import "VABridgeManager.h"
#import "VARootView.h"
#import "VADefine.h"
@interface ViolaInstance()

@property (nonatomic, copy ,readwrite) NSString * instanceId;
@property (nonatomic, strong ,readwrite) VARootView * rootView;
@property (nullable, nonatomic, strong) VAComponentController * componentController;
@property (nonnull, nonatomic, strong) NSMutableDictionary * modules;

@end

@implementation ViolaInstance


- (instancetype)init
{
    self = [super init];
    if (self) {
        static NSInteger instanceId = 0;
        if ([NSThread isMainThread]) {
              instanceId++;
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                instanceId++;
            });
        }
        _instanceId = [NSString stringWithFormat:@"%d", (int)instanceId];
        _modules = [NSMutableDictionary new];
        _componentController = [VAComponentController new];
        
        [VAInstanceManager setInstance:self forID:self.instanceId];

    }
    return self;
}

- (void)renderViewWithURL:(NSURL *)scriptURL data:(NSDictionary *)data{
    
}

- (void)renderViewWithScript:(NSString *)script data:(NSDictionary *)data{
    NSMutableDictionary * realData = [NSMutableDictionary dictionaryWithDictionary:data];
    
    [VAThreadManager performOnMainThreadWithBlock:^{
        _rootView = [[VARootView alloc] initWithFrame:self.instanceFrame];
        _rootView.vaInstance = self;
        //通过代理其实也不错的。。。。
//                if(self.onCreate) {//tomqiu todo
//                    self.onCreate(_rootView);
//                }
    }];
    [[VABridgeManager shareManager] executeJSScript:script];//tomqiu todo 
    
    [[VABridgeManager shareManager] createInstanceWithID:self.instanceId script:script data:realData];
}


- (id<VAModuleProtocol>)moduleWithClass:(Class)moduleClass{
    if (!moduleClass) return nil;
    NSString * className = NSStringFromClass(moduleClass);
    id<VAModuleProtocol> module = [self.modules objectForKey:className];
    if (!module) {
        module = [[moduleClass alloc] init];
        if ([module respondsToSelector:@selector(setVaInstance:)]){
            [module setVaInstance:self];
        }
        [self.modules setObject:module forKey:className];
    }
    return module;
}

- (VAComponent *)componentWithRef:(NSString *)ref{
    return [self.componentController componentWithRef:ref];
}

- (void)destroyInstance{
    
    [[VABridgeManager shareManager] destroyInstanceWithID:self.instanceId];//还有其他逻辑 稍后继续
    [VAInstanceManager removeInstanceWithID:_instanceId];
    
    kBlockWeakSelf;
    [VAThreadManager performOnComponentThreadWithBlock:^{
        kBlockStrongSelf;
        [strongSelf.componentController unload];
        [VAInstanceManager removeInstanceWithID:strongSelf.instanceId];
    }];
}

#pragma mark - getter

- (NSMutableDictionary *)modules{
    if (!_modules) {
        _modules = [NSMutableDictionary new];
    }
    return _modules;
}

#pragma mark - setter

- (void)setInstanceFrame:(CGRect)instanceFrame{
    if (!CGRectEqualToRect(instanceFrame, _instanceFrame)) {
        _instanceFrame = instanceFrame;
        kBlockWeakSelf;
        [VAThreadManager performOnMainThreadWithBlock:^{
            if (weakSelf.rootView) {
                weakSelf.rootView.frame = weakSelf.instanceFrame;
                [VAThreadManager performOnComponentThreadWithBlock:^{
                      [weakSelf.componentController rootViewFrameDidChange:weakSelf.instanceFrame];
                }];
            }
        }];
    }
}

@end
