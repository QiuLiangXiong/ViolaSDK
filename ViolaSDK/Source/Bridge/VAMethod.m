//
//  VAMethod.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAMethod.h"
#import "VAConvertUtl.h"
#import "VADefine.h"
#import "ViolaInstance.h"
#import "VABridgeManager.h"
#import "VARegisterManager.h"
#import "VAModuleProtocol.h"
#import "VAComponent.h"

@implementation VABridgeMethod

- (instancetype)initWithMethodName:(NSString *)methodName
                              arguments:(NSArray *)arguments
                          instance:(ViolaInstance *)instance{
    if (self = [super init]) {
        _methodName = methodName;
        _arguments = [NSMutableArray arrayWithArray:arguments];
        _instance = instance;
    }
    
    return self;
}
- (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector
{
    VAAssert(target && selector, @"target or selector is nil");
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        VAAssert(signature, @"signature is nil");
        return nil;
    }
    NSArray *arguments = _arguments;
    if (signature.numberOfArguments - 2 < arguments.count) {
        VAAssert(0, @"arguments count not fit selector");
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    NSString *instanceId = _instance.instanceId;
    void **freeList = NULL;

    NSMutableArray *blockArray = [NSMutableArray array];
    VA_ALLOC_FLIST(freeList, arguments.count);
    for (int i = 0; i < arguments.count; i ++ ) {
        id obj = arguments[i];
        const char *parameterType = [signature getArgumentTypeAtIndex:i + 2];
        obj = [self parseArgument:obj parameterType:parameterType order:i];
        static const char *blockType = @encode(typeof(^{}));
        id argument;
        if (!strcmp(parameterType, blockType)) {
            argument = [^void(NSString * data) {
                [[VABridgeManager shareManager] callJSCallback:instanceId func:(NSString *)obj data:data];
            } copy];
            [blockArray addObject:argument];
            [invocation setArgument:&argument atIndex:i + 2];
        } else {
            argument = obj;
            VA_ARGUMENTS_SET(invocation, signature, i, argument, freeList);
        }
    }
    [invocation retainArguments];
    VA_FREE_FLIST(freeList, arguments.count);
    return invocation;
}

-(id)parseArgument:(id)obj parameterType:(const char *)parameterType order:(int)order
{
    if (strcmp(parameterType,@encode(float))==0 || strcmp(parameterType,@encode(double))==0)
    {
        CGFloat value = [VAConvertUtl convertToFloat:obj];
        return [NSNumber numberWithDouble:value];
    } else if (strcmp(parameterType,@encode(int))==0) {
        NSInteger value = [VAConvertUtl convertToInteger:obj];
        return [NSNumber numberWithInteger:value];
    } else if(strcmp(parameterType,@encode(id))==0) {
        return obj;
    } else if(strcmp(parameterType,@encode(typeof(^{})))==0) {
        return obj;
    }
    return obj;
}

@end

@interface VAJSMethod()

@property (nullable, nonatomic, copy) NSString * moduleName;

@end

@implementation VAJSMethod

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(ViolaInstance *)instance
{
    if (self = [super initWithMethodName:methodName arguments:arguments instance:instance]) {
        self.moduleName = moduleName;
    }
    return self;
}

- (NSDictionary *)callJSTask
{
    return @{@"module":self.moduleName ?: @"",
             @"method":self.methodName ?: @"",
             @"args":self.arguments ?: @[]};
}
@end



@interface VAModuleMethod()

@property (nullable, nonatomic, copy) NSString * moduleName;

@end

@implementation VAModuleMethod

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(ViolaInstance *)instance
{
    if (self = [super initWithMethodName:methodName arguments:arguments instance:instance]) {
        self.moduleName = moduleName;
    }
    return self;
}

- (void)invoke{
    
    Class moduleClass = [VARegisterManager classWithModuleName:self.moduleName];
    SEL selector  = [VARegisterManager selectorWithModuleName:self.moduleName methodName:self.methodName];
    VAAssert(_moduleName && moduleClass && selector, @"can't be nil");
    
    if (moduleClass && selector) {
        id<VAModuleProtocol> module = [self.instance moduleWithClass:moduleClass];
        VAAssert([module respondsToSelector:selector], @"module not found seletor");
        if ([module respondsToSelector:selector]) {
            NSInvocation * invocation = [self invocationWithTarget:module selector:selector];
            if ([module respondsToSelector:@selector(performOnQueue)]) {
                dispatch_queue_t queue = [module performOnQueue];
                if (queue) {
                    dispatch_async(queue, ^{
                        [invocation invoke];
                    });
                }else {
                    [invocation invoke];
                }
                
            }else {
                [invocation invoke];
            }
        }
    }
}

@end

@interface VAComponentMethod()

@property (nullable, nonatomic, copy) NSString * componentRef;

@end

@implementation VAComponentMethod

- (instancetype)initWithComponentRef:(NSString *)componentRef methodName:(NSString *)methodName arguments:(NSArray *)arguments instance:(ViolaInstance *)instance{
    if (self = [super initWithMethodName:methodName arguments:arguments instance:instance]) {
        self.componentRef = componentRef;
    }
    return self;
}

- (void)invoke{
    
    VAComponent * component = [self.instance componentWithRef:self.componentRef];
    VAAssertReturn(component, @"component is nil");
    
    SEL selector  = [VARegisterManager selectorWithComponentName:component.type methodName:self.methodName];
    VAAssertReturn(selector, @"can't be nil");
    
    if (component && selector) {
        VAAssert([component respondsToSelector:selector], @"component not found seletor");
        if ([component respondsToSelector:selector]) {
            NSInvocation * invocation = [self invocationWithTarget:component selector:selector];
            if ([component respondsToSelector:@selector(performOnQueue)]) {
                dispatch_queue_t queue = [(id)component performOnQueue];
                if (queue) {
                    dispatch_async(queue, ^{
                        [invocation invoke];
                    });
                }else {
                    [VAThreadManager performOnComponentThreadWithBlock:^{
                        [invocation invoke];
                    }];
                }
            }else {
                [VAThreadManager performOnComponentThreadWithBlock:^{
                    [invocation invoke];
                }];
            }
        }
    }
}


@end




