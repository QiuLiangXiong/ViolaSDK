//
//  VAJSContext.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef void (^VAJSCallNative)(NSString *instanceID, NSArray *tasks);
@interface VAJSContext : NSObject
@property (nonatomic, readonly) JSValue* exception;
/**
 * 执行js脚本
 */
- (void)executeJavascript:(NSString *)script;
/**
 * 执行js中的全局方法
 * args 传递参数
 */
- (JSValue *)callJSMethod:(NSString *)method args:(NSArray*)args;
/**
 * 注册js调用原生时的回调
 */
- (void)registerCallNativeMethod:(NSString *)method callbackBlock:(VAJSCallNative)callNative;

@end
