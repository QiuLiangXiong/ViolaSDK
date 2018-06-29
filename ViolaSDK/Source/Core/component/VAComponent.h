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
@property(nonatomic, readonly, strong) ViolaInstance  * violaInstance;
@property(nonatomic, readonly, assign) CGRect  componentFrame ;
@property(nonatomic, readonly, assign) UIEdgeInsets  contentEdge;
@property (nonatomic, assign) BOOL isRootComponent;
@property (nonatomic, assign) BOOL animatedEnable;


- (UIView *)loadView;//主线程

- (BOOL)isViewLoaded;

- (void)viewWillLoad;//主线程

//子类一般会在这里做很多view相关的事情，比如手势，比如atts

- (void)viewDidLoad;//主线程

- (void)viewWillUnload;//主线程  

- (void)viewDidUnload;//主线程

- (void)setNeedsLayout;//组件线程

- (BOOL)isNeedsLayout;//组件线程
//计算大小
- (nullable CGSize (^)(CGSize constrainedSize))calculateComponentSizeBlock;//组件线程


// 组件线程
- (void)layoutDidEnd;
//主线程
- (void)mainQueueWillSyncBeforeAnimation;

//该组件的frame变化回调  此时view的frame还没有同步过来
- (void)componentFrameDidChange;// 组件线程
- (void)componentFrameDidChangeOnMainQueue;// 主线程 此时view的frame已经同步过来
- (void)componentFrameWillChange;// 组件线程


//更新相关
- (void)updateStylesOnComponentThread:(NSDictionary *)styles;//组件线程更新
- (void)updateStylesOnMainThread:(NSDictionary *)styles;//主线程更新 该更新会比组件线程更新晚一步
- (void)updateAttributesOnComponentThread:(NSDictionary *)attributes;//组件线程更新
- (void)updateAttributesOnMainThread:(NSDictionary *)attributes;//主线程更新

- (void)updateComponentOnComponentThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events;//组件线程更新
- (void)updateComponentOnMainThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events;//主线程更新


- (void)updateEventsOnComponentThread:(NSArray *)events;//组件线程更新
- (void)updateEventsOnMainThread:(NSArray *)events;//主线程更新

//组件增删改
- (void)insertSubview:(VAComponent *)subcomponent atIndex:(NSUInteger)index;//主线程更新

- (void)moveToSuperview:(VAComponent *)supercomponent atIndex:(NSUInteger)index;//主线程更新

- (void)removeFromSuperview;//主线程更新
- (void)willMoveToSuperview:(nullable UIView *)newSuperview;
- (void)didMoveToSuperview;
@end


@interface UIView (VAComponent)

@property (nonatomic, weak) VAComponent *va_component;


@end

NS_ASSUME_NONNULL_END
