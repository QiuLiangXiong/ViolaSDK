//
//  QLXHttpRequest.h
//  单个网络请求  可以对这个请求控制(取消 ， 恢复  暂停 之类的 )
//
//  Created by QLX on 15/12/20.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLXHttpRequest : NSObject

-(instancetype) initWithTask:(id) task;

/**
 *  取消请求
 *  注意：取消后会马上调用response闭包 error.code == -999
 */
- (void)cancel;
// 暂停请求
- (void)suspend;
// 恢复请求
- (void)resume;
/**
 *  是否在请求中
 *
 *  @return 是 否
 */
-(BOOL) isRequesting;

@end
