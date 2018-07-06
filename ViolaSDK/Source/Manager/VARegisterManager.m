//
//  VARegisterManager.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VARegisterManager.h"
#import "VADefine.h"
#import "VAModuleProtocol.h"
#import "VABridgeManager.h"

@interface VAClassInfo:NSObject

@property (nullable, nonatomic, strong) Class aClass;
@property (nullable, nonatomic, strong) NSMutableDictionary * methodsDic;
@property (nullable, nonatomic, strong) NSMutableArray * methods;


@end

@implementation VAClassInfo


- (void)setAClass:(Class)aClass{
    _aClass = aClass;
    [self methodsDic];
}

- (NSMutableDictionary *)methodsDic{
    if(!_methodsDic){
        _methodsDic = [NSMutableDictionary new];
        _methods = [NSMutableArray new];
        Class currentClass = self.aClass;
        while (currentClass && currentClass != [NSObject class] && [currentClass conformsToProtocol:@protocol(VAModuleProtocol)] ) {
            unsigned int methCount = 0;
            Method *meths = class_copyMethodList(currentClass, &methCount);
            for(int i = 0; i < methCount; i++) {
                Method meth = meths[i];
                SEL sel = method_getName(meth);
                
                NSString * selName = NSStringFromSelector(sel);
                if(selName.length && [selName hasPrefix:@"va_"]){
                    NSString * name = nil;
                    NSRange range = [selName rangeOfString:@":"];
                    if (range.location != NSNotFound) {
                        name = [selName substringToIndex:range.location];
                    } else {
                        name = selName;
                    }
                    [_methodsDic setObject:selName forKey:name];
                    NSString * jsMethodName = [name substringFromIndex:3];
                    if (jsMethodName) {
                        [_methods addObject:jsMethodName];
                    }
                }
            }
            free(meths);
            currentClass = class_getSuperclass(currentClass);
        }
    }
    return _methodsDic;
}

@end

@interface VARegisterManager()

@property (nullable, nonatomic, strong) NSMutableDictionary * modulesDic;
@property (nullable, nonatomic, strong) NSMutableDictionary * componentsDic;
@property (nullable, nonatomic, strong) NSMutableDictionary * handlersDic;

@end

@implementation VARegisterManager

+ (instancetype)_getInstance{
    static VARegisterManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [VARegisterManager new];
    });
    return instance;
}


+ (void)registerModuleWithName:(NSString *)name moduleCalss:(Class)aClass{
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        [[self _getInstance] _registerModuleWithName:name moduleClass:aClass];
    }];
}
+ (void)registerComponentWithName:(NSString *)name componentCalss:(Class)aClass{
    [VAThreadManager performOnComponentThreadWithBlock:^{
        [[self _getInstance] _registerComponentWithName:name componentCalss:aClass];
    }];
}
+ (void)registerHandler:(id)handler protocol:(Protocol *)protocol{
    [VAThreadManager performOnComponentThreadWithBlock:^{
        [[self _getInstance] _registerHandler:handler protocol:protocol];
    }];
}

+ (Class)classWithModuleName:(NSString *)name{
    return  [[self _getInstance] _classWithModuleName:name];
}

+ (Class)classWithComponentType:(NSString *)type{
    return  [[self _getInstance] _classWithComponentTypeName:type];
}

+ (SEL)selectorWithModuleName:(NSString *)moduleName methodName:(NSString *)methodName{
    return [[self _getInstance] _selectorWithModuleName:moduleName methodName:methodName];
}

+ (SEL)selectorWithComponentName:(NSString *)componentName methodName:(NSString *)methodName{
    return  [[self _getInstance] _selectorWithComponentName:componentName methodName:methodName];
}

+ (id)handlerWithProtocol:(Protocol *)protocol{
    return [[self _getInstance] _handlerWithProtocol:protocol];
}

#pragma mark - private methods

- (void)_registerModuleWithName:(NSString *)name  moduleClass:(Class)aClass{
    if ([name isKindOfClass:[NSString class]] && aClass) {
        if (!self.modulesDic[name]) {
            VAClassInfo * info = [VAClassInfo new];
            info.aClass = aClass;
            [self.modulesDic setObject:info forKey:name];
            [[VABridgeManager shareManager] registerModuleWithName:name methods:info.methods];
            
        }
    }
}

- (void)_registerComponentWithName:(NSString *)name  componentCalss:(Class)aClass{
    if ([name isKindOfClass:[NSString class]] && aClass) {
        if (!self.componentsDic[name]) {
            VAClassInfo * info = [VAClassInfo new];
            info.aClass = aClass;
            [self.componentsDic setObject:info forKey:name];
            [[VABridgeManager shareManager] registerComponentWithName:name methods:info.methods];
        }
    }
}

- (void)_registerToBridgeWithName:(NSString *)name methodsDic:(NSDictionary *)methodsDic{
//    if (name && methodsDic) {
//
//    }
}

- (Class)_classWithModuleName:(NSString *)name{
    if([name isKindOfClass:[NSString class]]){
      VAClassInfo * info = (VAClassInfo *)[self.modulesDic objectForKey:name];
      return info.aClass;
    }
    return nil;
}


- (Class)_classWithComponentTypeName:(NSString *)name{
    if([name isKindOfClass:[NSString class]]){
        VAClassInfo * info = (VAClassInfo *)[self.componentsDic objectForKey:name];
        return info.aClass;
    }
    return nil;
}


- (SEL)_selectorWithModuleName:(NSString *)moduleName methodName:(NSString *)methodName{
    if ([moduleName isKindOfClass:[NSString class]] && [methodName isKindOfClass:[NSString class]]) {
        methodName = [@"va_" stringByAppendingString:methodName];
        VAClassInfo * info = self.modulesDic[moduleName];
        if (info) {
            NSString * method = [info.methodsDic objectForKey:methodName];
            if ([method isKindOfClass:[NSString class]]) {
                return NSSelectorFromString(method);
            }
        }
    }
    return nil;
}

- (SEL)_selectorWithComponentName:(NSString *)componentName methodName:(NSString *)methodName{
    if ([componentName isKindOfClass:[NSString class]] && [methodName isKindOfClass:[NSString class]]) {
        
        VAClassInfo * info = self.componentsDic[componentName];
        if (info) {
            methodName = [@"va_" stringByAppendingString:methodName];
            NSString * method = [info.methodsDic objectForKey:methodName];
            if ([method isKindOfClass:[NSString class]]) {
                return NSSelectorFromString(method);
            }
        }
    }
    return nil;
}

- (void)_registerHandler:(id)handler protocol:(Protocol *)protocol{
    if (handler && protocol) {
        [self.handlersDic setObject:handler forKeyedSubscript:NSStringFromProtocol(protocol)];
    }
}
- (id)_handlerWithProtocol:(Protocol *)protocol{
    if (protocol) {
        return [self.handlersDic objectForKey:NSStringFromProtocol(protocol)];
    }
    return nil;
}

#pragma mark - getter

- (NSMutableDictionary *)modulesDic{
    if (!_modulesDic) {
        _modulesDic = [NSMutableDictionary new];
    }
    return _modulesDic;
}

- (NSMutableDictionary *)componentsDic{
    if (!_componentsDic) {
        _componentsDic = [NSMutableDictionary new];
    }
    return _componentsDic;
}

- (NSMutableDictionary *)handlersDic{
    if (!_handlersDic) {
        _handlersDic = [NSMutableDictionary new];
    }
    return _handlersDic;
}

@end


