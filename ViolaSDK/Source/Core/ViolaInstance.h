//
//  ViolaInstance.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol VAModuleProtocol;
@class VAComponent;
@class VARootView;
@interface ViolaInstance : NSObject

/*
 * 实例唯一ID
 */
@property (nonatomic, copy ,readonly) NSString * instanceId;

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
NS_ASSUME_NONNULL_END
