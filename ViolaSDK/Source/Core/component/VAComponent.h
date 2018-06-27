//
//  VAComponent.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN

@class ViolaInstance;
@interface VAComponent : NSObject

- (instancetype)initWithRef:(NSString *)ref
                       type:(NSString*)type
                     styles:(nullable NSDictionary *)styles
                 attributes:(nullable NSDictionary *)attributes
                     events:(nullable NSArray *)events
               weexInstance:(ViolaInstance *)violaInstance;

@property (nonatomic, readonly, copy) NSString *ref;

@property (nonatomic, readonly, copy) NSString *type;

@property(nonatomic, readonly, strong) UIView *view;

@property (nonatomic, readonly, weak, nullable) VAComponent *supercomponent;
@property(nonatomic, readonly, strong) NSMutableArray  * subcomponents;
@property(nonatomic, readonly, strong) UIColor  * backgroundColor;
@property (nonatomic, assign) BOOL isRootComponent;


- (UIView *)loadView;

- (BOOL)isViewLoaded;

- (void)viewWillLoad;

- (void)viewDidLoad;

- (void)viewWillUnload;

- (void)viewDidUnload;

- (void)setNeedsLayout;

- (BOOL)isNeedsLayout;
//计算大小
- (nullable CGSize (^)(CGSize constrainedSize))calculateComponentSizeBlock;


// 组件线程
- (void)layoutDidEnd;
- (void)mainQueueWillSyncBeforeAnimation;

//该组件的frame变化回调  此时view的frame还没有同步过来
- (void)componentFrameDidChange;// 组件线程
- (void)componentFrameWillChange;// 组件线程

//更新相关
//组件线程更新
- (void)updateStylesOnComponentThread:(NSDictionary *)styles;
- (void)updateStylesOnMainThread:(NSDictionary *)styles;//主线程更新 该更新会比组件线程更新晚一步
- (void)updateAttributesOnComponentThread:(NSDictionary *)attributes;
- (void)updateAttributesOnMainThread:(NSDictionary *)attributes;

- (void)updateEventsOnComponentThread:(NSArray *)events;
- (void)updateEventsOnMainThread:(NSArray *)events;

- (void)insertSubview:(VAComponent *)subcomponent atIndex:(NSUInteger)index;

- (void)moveToSuperview:(VAComponent *)supercomponent atIndex:(NSUInteger)index;

- (void)removeFromSuperview;
@end


@interface UIView (VAComponent)

@property (nonatomic, weak) VAComponent *va_component;


@end

NS_ASSUME_NONNULL_END
