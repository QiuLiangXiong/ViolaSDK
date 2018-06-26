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

@implementation VADomModule
@synthesize vaInstance;
- (void)createBody:(NSDictionary *)body{
    VALogDebug(@"%s_%@",__func__,body);
    VAAssertReturn(self.vaInstance, @"can't be nil");
    [self.vaInstance.componentController createBody:body];
}


- (void)addComponent:(NSString *)parentRef componentData:(NSDictionary *)componentData atIndex:(NSInteger)index{
   [self.vaInstance.componentController addComponent:componentData toSupercomponent:parentRef atIndex:index];
}
#pragma mark - VAModuelProtocol
- (dispatch_queue_t)performOnQueue{
    return [VAThreadManager getComponentQueue];
}


@end
