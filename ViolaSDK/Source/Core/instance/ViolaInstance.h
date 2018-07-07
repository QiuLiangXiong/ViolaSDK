//
//  ViolaInstance.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VAComponentController.h"
#import "VARootView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol VAModuleProtocol;
@protocol ViolaInstanceDelegate;
@class VAComponent;
@class VARootView;
@interface ViolaInstance : NSObject

@property (nullable, nonatomic,weak) id<ViolaInstanceDelegate> delegate;

/*
 * 实例唯一ID
 */
@property (nonatomic, copy ,readonly) NSString * instanceId;

@property (nonatomic, assign) CGRect instanceFrame;

@property (nonatomic, weak,nullable) UIViewController * viewController;

@property (nonatomic, strong ,readonly) VARootView * rootView;

@property (nonnull, nonatomic, strong, readonly) VAComponentController * componentController;

@property (nonatomic, strong) UIColor * rootViewBackgroundColor;

//@property (nonatomic, weak) ViolaInstance * parentInstance;



//- (void)renderViewWithURL:(NSURL *)scriptURL data:(NSDictionary *)data;

- (void)renderViewWithScript:(NSString *)script data:(NSDictionary *)data url:(NSString *)url;


- (id<VAModuleProtocol>)moduleWithClass:(Class)moduleClass;

- (VAComponent * _Nullable)componentWithRef:(NSString *)ref;

- (void)refreshInstance:(NSDictionary *)data;
- (void)destroyInstance;


//添加主线程任务
- (void)addTaskToMainQueue:(dispatch_block_t)block;





@end

@protocol ViolaInstanceDelegate<NSObject>

- (void)violaIntance:(ViolaInstance *)instance didCreatedView:(UIView *)view;
@optional
- (void)renderFinishWithViolaIntance:(ViolaInstance *)instance ;

@end
NS_ASSUME_NONNULL_END
