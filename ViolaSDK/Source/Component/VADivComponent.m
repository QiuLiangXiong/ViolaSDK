//
//  VADivComponent.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/6/23.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VADivComponent.h"
#import "VAThreadManager.h"
#import "VAComponent+private.h"
@implementation VADivComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(ViolaInstance *)violaInstance{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:violaInstance]) {
//        if ([ref isEqualToString:@"20"]) {
//            [VAThreadManager performOnComponentThreadWithBlock:^{
//                if ([self.ref isEqualToString:@"20"]) {
//                    [self _updateLayoutWithStyles:@{@"height":@"500px",@"margin":@"20dp"}];
//                }
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    [self _updateViewPropWithStyles:@{@"backgroundColor":@"black"}];
////                });
//
//            } afterDelay:1];
//        }
      
    }
    return self;
}

@end
