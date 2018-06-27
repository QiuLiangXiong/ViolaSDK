//
//  VADomModule.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VADomModule.h"
#import "VALog.h"
#import "VADefine.h"
#import "VAThreadManager.h"
#import "VAConvertUtl.h"

@implementation VADomModule
@synthesize vaInstance;
- (void)createBody:(NSDictionary *)body{
    VALogDebug(@"%s_%@",__func__,body);
    VAAssertReturn(self.vaInstance, @"can't be nil");
    [self.vaInstance.componentController createBody:body];
}
//添加component
- (void)addComponent:(NSString *)parentRef componentData:(NSDictionary *)componentData atIndex:(NSInteger)index{
   [self.vaInstance.componentController addComponent:componentData toSupercomponent:parentRef atIndex:index];
}
//删除component
- (void)removeComponent:(NSString *)ref animated:(NSNumber *)animated{
    if (animated) {
        BOOL isAnimated = [VAConvertUtl convertToBOOL:animated];
        self.self.vaInstance.componentController.mainQueueSyncWithAnimated = isAnimated;
    }
    [self.vaInstance.componentController removeComponent:ref];
}
//更新component
-(void)updateComponent:(NSDictionary *)componentData{
    [self.vaInstance.componentController updateComponentWithComponentData:componentData];
}
//移动component
- (void)moveComponent:(NSString *)ref toParent:(NSString *)parentRef index:(NSInteger)index{
    [self.vaInstance.componentController moveComponentWithRef:ref toParent:parentRef atIndex:index];
}

#pragma mark - VAModuelProtocol
- (dispatch_queue_t)performOnQueue{
    return [VAThreadManager getComponentQueue];
}


@end
