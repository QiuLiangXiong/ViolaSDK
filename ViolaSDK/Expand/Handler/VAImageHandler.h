//
//  VAImageHandler.h
//  ViolaSDK
//
//  Created by QLX on 2018/7/2.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VAImageHandlerProtocol.h"
#import "YYWebImageManager.h"
#import "YYWebImageOperation.h"
@interface VAImageHandler : NSObject<VAImageHandlerProtocol>

@end

@interface VAImageOperation : NSObject<VAImageOperationProtocol>

@property (nullable, nonatomic, strong) YYWebImageOperation * imageOpertaion;

@end

