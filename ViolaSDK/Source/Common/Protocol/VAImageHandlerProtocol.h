//
//  VAImageHandlerProtocol.h
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/2.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VAImageOperationProtocol <NSObject>

- (void)cancel;

@end

@protocol VAImageHandlerProtocol <NSObject>

- (id<VAImageOperationProtocol>)downloadImageWithUrl:(NSString *)url contentMode:(UIViewContentMode)contentMode imageFrame:(CGRect)frame options:(NSDictionary *)options completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock;

@end
