//
//  VAComponentController.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class VAComponent;
@class ViolaInstance;
@interface VAComponentController : NSObject

@property (nullable, nonatomic,weak) ViolaInstance * vaInstance;


- (VAComponent *)componentWithRef:(NSString *)ref;

- (void)rootViewFrameDidChange:(CGRect)frame;

- (void)unload;

@end
NS_ASSUME_NONNULL_END
