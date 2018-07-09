//
//  VAMethod.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/19.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ViolaInstance;
NS_ASSUME_NONNULL_BEGIN
@interface VABridgeMethod : NSObject
@property (nonatomic, strong, readonly) NSString *methodName;
@property (nonatomic, copy, readonly) NSMutableArray *arguments;
@property (nonatomic, weak, readonly) ViolaInstance *instance;

- (instancetype)initWithMethodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(ViolaInstance *)instance;

- (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector;

@end

@interface VAJSMethod : VABridgeMethod

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(ViolaInstance *)instance;

@property(nullable, nonatomic, strong) NSDictionary * data;

- (NSDictionary *)callJSTask;

@end

@interface VAModuleMethod : VABridgeMethod

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(ViolaInstance *)instance;
- (void)invoke;
@end
@interface VAComponentMethod : VABridgeMethod

- (instancetype)initWithComponentRef:(NSString *)componentRef
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(ViolaInstance *)instance;
- (void)invoke;
@end
NS_ASSUME_NONNULL_END
