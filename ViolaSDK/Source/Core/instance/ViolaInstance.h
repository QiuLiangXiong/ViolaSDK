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
@property (nonnull, nonatomic, strong, readonly) VAComponentController * componentController;

@property (nonatomic, assign) CGRect instanceFrame;

@property (nonatomic, weak,nullable) UIViewController * viewController;


@property (nonatomic, strong ,readonly) VARootView * rootView;
/**
 * js脚本url
 **/
@property (nonatomic, strong,nullable) NSURL * scriptURL;

@property (nonatomic, weak) ViolaInstance * parentInstance;



- (void)renderViewWithURL:(NSURL *)scriptURL data:(NSDictionary *)data;

- (void)renderViewWithScript:(NSString *)script data:(NSDictionary *)data;


- (id<VAModuleProtocol>)moduleWithClass:(Class)moduleClass;

- (VAComponent * _Nullable)componentWithRef:(NSString *)ref;

- (void)destroyInstance;





//- (void)refreshInstance:(id)data;





@end

@protocol ViolaInstanceDelegate<NSObject>

- (void)violaIntance:(ViolaInstance *)instance didCreatedView:(UIView *)view;

@end
NS_ASSUME_NONNULL_END
