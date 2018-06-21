//
//  VAInstanceManager.m
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import "VAInstanceManager.h"
#import "VAThreadManager.h"

@interface VAInstanceManager()

@property (nullable, nonatomic, strong) NSMutableDictionary * instances;

@end

@implementation VAInstanceManager

+ (instancetype )_getInstance{
    static VAInstanceManager * instance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VAInstanceManager alloc] init];
    });
    return instance;
}

+ (ViolaInstance *)getInstanceWithID:(NSString *)instanceID{
    __block ViolaInstance * res = nil;
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        if ([instanceID isKindOfClass:[NSString class]]) {
            res = [[[self _getInstance] getInstancesDic] objectForKey:instanceID];
        }
    } waitUntilDone:true];
    return res;
}

+ (void)setInstance:(ViolaInstance *)instance forID:(NSString *)instanceID{
    
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        if ([instanceID isKindOfClass:[NSString class]]) {
            [[[self _getInstance] getInstancesDic] setObject:instance forKey:instanceID];
        }
    } waitUntilDone:false];
}

+ (void)removeInstanceWithID:(NSString *)instanceID{
    [VAThreadManager performOnBridgeThreadWithBlock:^{
        if ([instanceID isKindOfClass:[NSString class]]) {
            [[[self _getInstance] getInstancesDic] removeObjectForKey:instanceID];
        }
    } waitUntilDone:false];
}

- (NSMutableDictionary *)getInstancesDic{
    if (!_instances) {
        _instances = [NSMutableDictionary new];
    }
    return _instances;
}


@end
