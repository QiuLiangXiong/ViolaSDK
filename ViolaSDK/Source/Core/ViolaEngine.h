//
//  ViolaEngine.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViolaEngine : NSObject

/**
 * 启动引擎
 **/
+ (void)startEngine;

/**
 * 注册 module
 * @param name moduleName
 * @param aClass 实现VAModuleProtocol协议的类
 **/
+ (void)registerModule:(NSString *)name withClass:(Class)aClass;

/**
 * 注册 component
 * @param name componentName
 * @param aClass VAComponent 子类
 *
 **/
+ (void)registerComponent:(NSString *)name withClass:(Class)aClass;

/**
 * 注册 handler
 * @param handler  如[VAImageHandler new]
 * @param protocol  协议 如@protocol(VAImageHandler)
 */
+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol;




@end
