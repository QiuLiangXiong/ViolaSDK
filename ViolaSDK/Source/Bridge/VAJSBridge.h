//
//  VAJSBridge.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VAMethod.h"

@interface VAJSBridge : NSObject

/**
 * 执行JS脚本
 **/
- (void)executeJSScript:(NSString *)script;

/**
 * 调用js方法
 **/
- (void)callJSMethod:(VAJSMethod *)jsMethod;

/**
 *  创建实例
 **/
- (void)createInstanceWithID:(NSString *)instanceID
              script:(NSString *)script
                  data:(NSDictionary *)data;
/**
 * 销毁实例
 **/
- (void)destroyInstanceWithID:(NSString *)instanceID;
/**
 * 更新实例
 **/
- (void)updateInstance:(NSString *)instance
               param:(NSDictionary *)param;
/*
 * 注册module
 */
- (void)registerModuleWithName:(NSString *)name methods:(NSArray *)methods;
- (void)registerComponentWithName:(NSString *)name methods:(NSArray *)methods;

@end
