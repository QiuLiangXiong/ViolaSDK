//
//  QLXHttpRequest.m
//  FunPoint
//
//  Created by QLX on 15/12/20.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXHttpRequest.h"

@interface QLXHttpRequest()
//NSURLSessionDownloadTask NSURLSessionDataTask
@property(nonatomic , weak) id task;
@end

@implementation QLXHttpRequest

-(instancetype) initWithTask:(id) task{
    self = [self init];
    if (self) {
        self.task =  task;
    }
    return self;
}

// 取消取请求
- (void)cancel{
    if ([self.task isKindOfClass:[NSURLSessionDataTask class]]) {
        NSURLSessionDataTask * task = ( NSURLSessionDataTask *)self.task;
        [task cancel];
    }else  if([self.task isKindOfClass:[NSURLSessionDownloadTask class]]){
        NSURLSessionDownloadTask * task = ( NSURLSessionDownloadTask *)self.task;
        [task cancel];
    }
}
// 暂停请求
- (void)suspend{
    if ([self.task isKindOfClass:[NSURLSessionDataTask class]]) {
        NSURLSessionDataTask * task = ( NSURLSessionDataTask *)self.task;
        [task suspend];
    }else  if([self.task isKindOfClass:[NSURLSessionDownloadTask class]]){
        NSURLSessionDownloadTask * task = ( NSURLSessionDownloadTask *)self.task;
        [task suspend];
    }
}
// 恢复请求
- (void)resume{
    if ([self.task isKindOfClass:[NSURLSessionDataTask class]]) {
        NSURLSessionDataTask * task = ( NSURLSessionDataTask *)self.task;
        [task resume];
    }else  if([self.task isKindOfClass:[NSURLSessionDownloadTask class]]){
        NSURLSessionDownloadTask * task = ( NSURLSessionDownloadTask *)self.task;
        [task resume];
    }
}

-(BOOL) isRequesting{
    if ([self.task isKindOfClass:[NSURLSessionDataTask class]]) {
        NSURLSessionDataTask * task = ( NSURLSessionDataTask *)self.task;
        return task.state == NSURLSessionTaskStateRunning;
    }else  if([self.task isKindOfClass:[NSURLSessionDownloadTask class]]){
        NSURLSessionDownloadTask * task = ( NSURLSessionDownloadTask *)self.task;
        return task.state == NSURLSessionTaskStateRunning;
    }
    return false;
}
@end
