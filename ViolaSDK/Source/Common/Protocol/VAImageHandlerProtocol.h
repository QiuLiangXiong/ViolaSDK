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

@property (nullable, nonatomic, strong) NSString * imageUrl;
@property (nullable, nonatomic, strong) UIImage * image;
@property (nullable, nonatomic, strong) NSError * error;

@end

@protocol VAImageHandlerProtocol <NSObject>

- (id<VAImageOperationProtocol>)downloadImageWithUrl:(NSString *)url contentMode:(UIViewContentMode)contentMode imageFrame:(CGRect)frame options:(NSDictionary *)options completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock;

@end
