//
//  VABundleManager.h
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/4.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kVABaseUrl @""
NS_ASSUME_NONNULL_BEGIN
@interface VABundleManager : NSObject
typedef void (^VABundleReponse)(NSString * _Nullable script, NSError *_Nullable error);   // 请求结果闭包
+ (VABundleManager *)shareManager;

- (NSString * _Nullable)getLocalScriptWithUrl:(NSString *)url;

- (void)downloadJSFileWithUrl:(NSString *)url completedBlocK:(VABundleReponse)completed;


@end
NS_ASSUME_NONNULL_END
