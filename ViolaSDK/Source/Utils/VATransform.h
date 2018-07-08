//
//  VATransform.h
//  ViolaSDK
//
//  Created by QLX on 2018/7/8.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VATransform : NSObject

- (instancetype)initWithCSSTransform:(NSString *)transform cssOrigin:(NSString *)origin;
- (void)transformToView:(UIView *)view;

@end
