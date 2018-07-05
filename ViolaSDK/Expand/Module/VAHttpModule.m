//
//  VAHttpModule.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/4.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAHttpModule.h"
#import "QLXHttpRequestTool.h"
#import "VADefine.h"
@interface VAHttpModule()

@end
@implementation VAHttpModule

- (void)va_requestGet:(NSString *)url param:(NSDictionary *)param response:(VAModuleCallback)block{
    if ([url isKindOfClass:[NSString class]]) {
        kBlockWeakSelf;
        [QLXHttpRequestTool requestForGetWithUrl:url params:param response:^(id  _Nullable data, NSError * _Nullable error) {
          
            if (weakSelf && block) {
                NSDictionary * result = [data isKindOfClass:[NSDictionary class]] ? data: @{};
                NSUInteger code = error ? error.code:0;
                NSString * statusText = (error && error.domain) ? error.domain : @"";
                BOOL ok = error == nil;
                block(@{@"data":result,@"code":@(code),@"errorText":statusText,@"success":@(ok)});
            }
        }];
    }
    
}

- (void)va_requestPost:(NSString *)url param:(NSDictionary *)param response:(VAModuleCallback)block{
    if ([url isKindOfClass:[NSString class]]) {
        kBlockWeakSelf;
        [QLXHttpRequestTool requestForPostWithUrl:url params:param response:^(id  _Nullable data, NSError * _Nullable error) {
          
            if (weakSelf && block) {
                NSDictionary * result = [data isKindOfClass:[NSDictionary class]] ? data: @{};
                NSUInteger code = error ? error.code:0;
                NSString * statusText = (error && error.domain) ? error.domain : @"";
                BOOL ok = error == nil;
                block(@{@"data":result,@"code":@(code),@"errorText":statusText,@"success":@(ok)});
            }
        }];
    }
}


#pragma mark - getter


-(void)dealloc{
    
}

@end
