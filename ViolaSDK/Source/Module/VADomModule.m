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
    body = @{@"ref":@"1",@"type":@"div",@"style":@{@"backgroundColor":@"blue",@"width":@"750px",@"height":@"2112px"},
             @"children":@[
                     @{@"ref":@"2",@"type":@"div",@"style":@{@"backgroundColor":@"red",@"height":@"250px",@"margin":@"5dp"}},
                     @{@"ref":@"3",@"type":@"div",@"style":@{@"backgroundColor":@"yellow",@"width":@"250px",@"height":@"250px",@"margin":@"50dp"}},
                     @{@"ref":@"4",@"type":@"div",@"style":@{@"backgroundColor":@"black",@"width":@"250px",@"height":@"250px",@"margin":@"50"}},
                     ]
             };
             
    [self.vaInstance.componentController createBody:body];
}


- (void)test:(NSDictionary *)param0 callback:(VAModuleCallback)block{
    if (block) {
        block(param0);
    }

}
#pragma mark - VAModuelProtocol
- (dispatch_queue_t)performOnQueue{
    return [VAThreadManager getComponentQueue];
}


@end
