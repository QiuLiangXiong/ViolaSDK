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
#import "objc/runtime.h"
@interface ViolaInstance()<VAComponentControllerDelegate>

@property (nonatomic, copy ,readwrite) NSString * instanceId;
@property (nonatomic, strong ,readwrite) VARootView * rootView;

@property (nonnull, nonatomic, strong) NSMutableDictionary * modules;
@property (nonnull, nonatomic, strong, readwrite) VAComponentController * componentController;

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
        _componentController.vaInstance = self;
        _componentController.delegate = self;
        
        [VAInstanceManager setInstance:self forID:self.instanceId];

    }
    return self;
}


- (void)renderViewWithScript:(NSString *)script param:(NSDictionary * _Nullable)param url:(NSString *)url cachaData:(NSDictionary * _Nullable)cacheData{
    NSMutableDictionary * pageData = [NSMutableDictionary new];
    pageData[@"url"] = url ? : @"";
    pageData[@"param"] = param ? : @{};
    pageData[@"name"] = self.viewController ? NSStringFromClass([self.viewController class]):@"";
    pageData[@"cache"] = cacheData ? : @{};
    kBlockWeakSelf;
    [VAThreadManager performOnMainThreadWithBlock:^{
        _rootView = [[VARootView alloc] initWithFrame:self.instanceFrame];
        _rootView.vaInstance = self;
        if([weakSelf.delegate respondsToSelector:@selector(violaIntance:didCreatedView:)]){
            [weakSelf.delegate violaIntance:weakSelf didCreatedView:_rootView];
        }
    }];
    [[VABridgeManager shareManager] createInstanceWithID:self.instanceId script:script data:pageData];
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

- (void)refreshInstance:(NSDictionary *)data{
    [[VABridgeManager shareManager] updateInstance:_instanceId param:data];
}

- (void)destroyInstance{
    
    [[VABridgeManager shareManager] destroyInstanceWithID:self.instanceId];
    [VAInstanceManager removeInstanceWithID:_instanceId];

    self.componentController.isEnable = false;
    [VAInstanceManager removeInstanceWithID:self.instanceId];
    //    kBlockWeakSelf;
    //    [VAThreadManager performOnComponentThreadWithBlock:^{
    //        kBlockStrongSelf;
    ////        [strongSelf.componentController unload];//
    //
    //    }];
}

- (void)addTaskToMainQueue:(dispatch_block_t)block{
    VAAssertComponentThread();
    kBlockWeakSelf;
    [VAThreadManager performOnComponentThreadWithBlock:^{
        [weakSelf.componentController addTaskToMainQueueOnComponentThead:block];
    }];

}

#pragma mark VAComponentControllerDelegate

- (void)renderFinishWithComponentController:(VAComponentController *)componentController{
    if ([self.delegate respondsToSelector:@selector(renderFinishWithViolaIntance:)]) {
        [self.delegate renderFinishWithViolaIntance:self];
    }
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
        if(!weakSelf.rootView) return ;
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

- (void)dealloc{
    VALogDebug(@"instance_id_delloc:%@",_instanceId);
}


@end
