//
//  VARegisterManager.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VARegisterManager : NSObject

+ (void)registerModuleWithName:(NSString *)name moduleCalss:(Class)aClass;
+ (void)registerComponentWithName:(NSString *)name componentCalss:(Class)aCalss;
+ (void)registerHandler:(id)handler protocol:(Protocol *)protocol;

+ (Class)classWithModuleName:(NSString *)name;
+ (Class)classWithComponentType:(NSString *)type;

+ (SEL)selectorWithModuleName:(NSString *)moduleName methodName:(NSString *)methodName;

+ (SEL)selectorWithComponentName:(NSString *)componentName methodName:(NSString *)methodName;

+ (id)handlerWithProtocol:(Protocol *)protocol;

@end
