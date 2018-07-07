//
//  VABaseViewController.h
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/3.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViolaInstance.h"

NS_ASSUME_NONNULL_BEGIN
@interface VABaseViewController : UIViewController<ViolaInstanceDelegate>

@property (nullable, nonatomic, strong) ViolaInstance * instance;


/**
 * 渲染viola实例
 * 拿到脚本后调用该方法去渲染
 */
- (void)renderWithJSScript:(NSString * _Nonnull)script  pageParam:(NSDictionary * _Nullable)param pageUrl:(NSString *)url;


//可以重写
- (void)violaIntance:(ViolaInstance *)instance didCreatedView:(UIView *)view;
- (void)renderFinishWithViolaIntance:(ViolaInstance *)instance;

@end
NS_ASSUME_NONNULL_END
