//
//  VAComponentController.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/20.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VAComponent.h"
NS_ASSUME_NONNULL_BEGIN
@class VAComponent;
@class ViolaInstance;
@interface VAComponentController : NSObject

@property (nullable, nonatomic,weak) ViolaInstance * vaInstance;
@property (nullable, nonatomic, strong ,readonly) VAComponent * rootComponent;
@property (nonatomic, assign) BOOL isEnable;



- (void)createBody:(NSDictionary *)body;

- (VAComponent *)componentWithRef:(NSString *)ref;

- (void)rootViewFrameDidChange:(CGRect)frame;

- (void)unload;

- (void)addComponent:(NSDictionary *)componentData toSupercomponent:(NSString *)parentRef atIndex:(NSInteger)index;

- (void)addTaskToMainQueueOnComponentThead:(dispatch_block_t)block;
- (void)addTaskToMainQueueOnComponentThead:(dispatch_block_t)block withAnimated:(BOOL)animated;

- (void)setNeedsLayout;



@end
NS_ASSUME_NONNULL_END
