//
//  VAModuleProtocol.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViolaInstance.h"
/*
 * module只能使用该回调闭包
 */
typedef void (^VAModuleCallback)(id result);

@protocol VAModuleProtocol <NSObject>

@optional

/*
 *在指定队列执行
 */
- (dispatch_queue_t)performOnQueue;

/*
 * 自身对象在该viola实例下被创建
 */
@property (nonatomic, weak) ViolaInstance *vaInstance;

@end
