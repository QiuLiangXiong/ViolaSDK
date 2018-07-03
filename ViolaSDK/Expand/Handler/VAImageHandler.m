//
//  VAImageHandler.m
//  ViolaSDK
//
//  Created by QLX on 2018/7/2.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAImageHandler.h"
#import "YYImage.h"


@implementation VAImageHandler

- (id<VAImageOperationProtocol>)downloadImageWithUrl:(NSString *)url contentMode:(UIViewContentMode)contentMode imageFrame:(CGRect)frame options:(NSDictionary *)options completed:(void (^)(UIImage *, NSError *, BOOL))completedBlock{
    YYWebImageOperation * operation =  [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:url] options:(0) progress:nil transform:nil  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (completedBlock) {
            //支持高斯模糊
//            if (image && isBlued) {
//                image = [TFImageEffects tf_blurredImageWithImage:image];
//            }
            
            completedBlock(image, error, true);
        }
    }];
    
    VAImageOperation * imageOperation = [VAImageOperation new];
    imageOperation.imageOpertaion = operation;
    return imageOperation;
}

@end


@implementation VAImageOperation
@synthesize imageUrl;
@synthesize image;
@synthesize error;
- (void)cancel{
    [self.imageOpertaion cancel];
}

@end
