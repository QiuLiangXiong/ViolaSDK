//
//  VAComponentController.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAComponentController.h"
#import "VADefine.h"

@implementation VAComponentController

- (VAComponent *)componentWithRef:(NSString *)ref{
    VAAssertComponentThread();
    return nil;
}

- (void)rootViewFrameDidChange:(CGRect)frame{
    VAAssertComponentThread();
}

- (void)unload{
    VAAssertComponentThread();
}

@end
