//
//  QLXHttpRequestTool.h
//  网络请求工具类  基于 AFNetowrking 3.x 二次封装
//
//  Created by QLX on 15/12/20.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLXHttpRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class AFURLSessionManager;

// 这个data类型  一般是字典
typedef void (^QLXHTTPResponse)(id __nullable data, NSError *_Nullable error);   // 请求结果闭包
typedef void (^QLXHTTPProgress)(double progress);         // 请求过程闭包

@interface QLXHttpRequestTool : NSObject

/**
 *  GET类型 普通接口请求
 *  QLXHTTPResponse data 一般是字段类型
 *  @param url      请求链接
 *  @param params   请求参数
 *  @param complete 请求结束闭包
 *
 *  @return 本次请求对象 可以用来判断是否在请求中 或者可以取消该次请求
 */
+ (QLXHttpRequest *)requestForGetWithUrl:(NSString *)url params:(NSDictionary *)params response:(QLXHTTPResponse)complete NS_REQUIRES_SUPER;

/**
 *  POST类型 普通接口请求
 *  QLXHTTPResponse data 一般是字段类型
 *  @param url      请求链接
 *  @param params   请求参数
 *  @param complete 请求结束闭包
 *
 *  @return 本次请求对象 可以用来判断是否在请求中 或者可以取消该次请求
 */
+ (QLXHttpRequest *)requestForPostWithUrl:(NSString *)url params:(NSDictionary *)params response:(QLXHTTPResponse)complete NS_REQUIRES_SUPER;

/**
 *  上传文件
 *
 *  @param url        对应接口
 *  @param path       要上传文件的路径
 *  @param params     请求参数
 *  @param progress   进度回调闭包（主线程）
 *  @param completion 完成回调闭包
 *
 *  @return 本次请求对象 可以用来判断是否在请求中 或者可以取消该次请求
 */
+ (QLXHttpRequest *)uploadWithUrl:(NSString *)url filePath:(NSString *)path params:(NSDictionary *)params progress:(QLXHTTPProgress)progress completion:(QLXHTTPResponse)completion NS_REQUIRES_SUPER;

/**
 *  下载文件
 *  注意：QLXHTTPResponse 中 data 是文件保存路径 nsstring类型
 *  @param url        接口
 *  @param path       保存到的路径  可以是目录 也是可以是路径+文件名
 *  @param params     请求参数
 *  @param progress   进度回调闭包
 *  @param completion 完成回调闭包
 *
 *  @return 本次请求对象 可以用来判断是否在请求中 或者可以取消该次请求
 */
+ (QLXHttpRequest *)downloadWithUrl:(NSString *)url filePath:(NSString *)path params:(NSDictionary *)params progress:(QLXHTTPProgress)progress completion:(QLXHTTPResponse)completion NS_REQUIRES_SUPER;

/**
 *  返回一个自定义配置后manager实例
 *
 *  @return AFURLSessionManager 类型
 */
+(AFURLSessionManager *) defaultSessionManager;




@end

NS_ASSUME_NONNULL_END
