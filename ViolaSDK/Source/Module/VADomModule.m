//
//  VADomModule.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VADomModule.h"
#import "VALog.h"
#import "VADefine.h"
#import "VAThreadManager.h"
#import "VAConvertUtl.h"

@implementation VADomModule
@synthesize vaInstance;
- (void)va_createBody:(NSDictionary *)body{
    VALogDebug(@"%s_%@",__func__,body);
    VAAssertReturn(self.vaInstance, @"can't be nil");
    [self.vaInstance.componentController createBody:body];
}
//添加component
- (void)va_addElement:(NSString *)parentRef eleData:(NSDictionary *)eleData atIndex:(NSInteger)index {
    VALogDebug(@"%s_ref:%@  eleData:%@ index:%ld",__func__,parentRef, eleData,(long)index);
   [self.vaInstance.componentController addComponent:eleData toSupercomponent:parentRef atIndex:index];
}
//删除component
- (void)va_removeElement:(NSString *)ref {
    VALogDebug(@"%s_%@",__func__,ref);
    [self.vaInstance.componentController removeComponent:ref];
}
//更新component
-(void)va_updateElement:(NSString *)ref eleData:(NSDictionary *)eleData {
    VALogDebug(@"%s_ref:%@   eleData:%@",__func__,ref,eleData);
    [self.vaInstance.componentController updateComponentWithRef:ref componentData:eleData];
}
//移动component
- (void)va_moveElement:(NSString *)parentRef componentRef:(NSString *)ref index:(NSInteger)index{
    VALogDebug(@"%s_ref:%@  componentRef:%@ index:%ld",__func__,parentRef, ref,(long)index);
    [self.vaInstance.componentController moveComponentWithRef:ref toParent:parentRef atIndex:index];
}

#pragma mark - VAModuelProtocol
- (dispatch_queue_t)performOnQueue{
    return [VAThreadManager getComponentQueue];
}


@end
