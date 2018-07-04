//
//  VAModalUIModule.m
//  ViolaSDK
//
//  Created by gisonyang on 2018/7/3.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAModalUIModule.h"
#import <objc/runtime.h>
#import "VALog.h"
#import "VADefine.h"
#import "VAUtil.h"
#import "VAThreadManager.h"
#import "VAConvertUtl.h"


static NSString *VAModalCallbackKey;

typedef enum : NSUInteger {
    VAModalTypeToast = 1,
    VAModalTypeAlert,
    VAModalTypeConfirm,
    VAModalTypePrompt
} VAModalType;

@interface VAToastInfo : NSObject

@property (nonatomic, strong) UIView *toastView;
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, assign) double duration;

@end

@implementation VAToastInfo

@end

@interface VAToastManager : NSObject

@property (strong, nonatomic) NSMutableArray<VAToastInfo *> *toastQueue;
@property (strong, nonatomic) UIView *toastingView;

+ (VAToastManager *)sharedManager;

@end

@implementation VAToastManager

+ (VAToastManager *)sharedManager{
    static VAToastManager * shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[VAToastManager alloc] init];
        shareInstance.toastQueue = [NSMutableArray new];
    });
    return shareInstance;
}

@end

@interface VAModalUIModule () <UIAlertViewDelegate>

@end

@implementation VAModalUIModule
{
    NSMutableSet *_alertViews;
}
@synthesize vaInstance;

- (instancetype)init
{
    if (self = [super init]) {
        _alertViews = [NSMutableSet setWithCapacity:1];
    }
    
    return self;
}

- (void)dealloc
{
    if (VA_SYS_VERSION_LESS_THAN(@"8.0")) {
        for (UIAlertView *alerView in _alertViews) {
            alerView.delegate = nil;
        }
    }
    
    [_alertViews removeAllObjects];
}

#pragma mark - Toast

static const double VAToastDefaultDuration = 3.0;
static const CGFloat VAToastDefaultFontSize = 16.0;
static const CGFloat VAToastDefaultWidth = 230.0;
static const CGFloat VAToastDefaultHeight = 30.0;
static const CGFloat VAToastDefaultPadding = 30.0;

- (void)toast:(NSDictionary *)param
{
    NSString *message = [VAConvertUtl convertToString:param[@"message"]];
    
    if (!message) return;
    
    double duration = [param[@"duration"] doubleValue];
    if (duration <= 0) {
        duration = VAToastDefaultDuration;
    }
    
    [VAThreadManager performOnMainThreadWithBlock:(^{
        [self toast:message duration:duration];
    })];
}

- (void)toast:(NSString *)message duration:(double)duration
{
    VAAssertMainThread();
    UIView *superView = self.vaInstance.rootView.window;
    if (!superView) {
        superView =  self.vaInstance.rootView;
    }
    UIView *toastView = [self toastViewForMessage:message superView:superView];
    VAToastInfo *info = [VAToastInfo new];
    info.toastView = toastView;
    info.superView = superView;
    info.duration = duration;
    [[VAToastManager sharedManager].toastQueue addObject:info];
    
    if (![VAToastManager sharedManager].toastingView) {
        [self showToast:toastView superView:superView duration:duration];
    }
}

- (UIView *)toastViewForMessage:(NSString *)message superView:(UIView *)superView
{
    CGFloat padding = VAToastDefaultPadding;
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding/2, padding/2, VAToastDefaultWidth, VAToastDefaultHeight)];
    messageLabel.numberOfLines =  0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = message;
    messageLabel.font = [UIFont boldSystemFontOfSize:VAToastDefaultFontSize];
    messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    [messageLabel sizeToFit];
    
    UIView *toastView = [[UIView alloc] initWithFrame:
                         CGRectMake(
                                    (superView.frame.size.width-messageLabel.frame.size.width-padding)/2,
                                    (superView.frame.size.height-messageLabel.frame.size.height-padding)/2,
                                    messageLabel.frame.size.width+padding,
                                    messageLabel.frame.size.height+padding
                                    )];
    
    CGPoint point = CGPointZero;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    // adjust to screen orientation
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait: {
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown: {
            toastView.transform = CGAffineTransformMakeRotation(M_PI);
            float width = window.frame.size.width;
            float height = window.frame.size.height;
            point = CGPointMake(width/2, height/2);
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            toastView.transform = CGAffineTransformMakeRotation(M_PI/2); //rotation in radians
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            toastView.transform = CGAffineTransformMakeRotation(-M_PI/2);
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            break;
        }
        default:
        break;
    }
    
    toastView.center = point;
    toastView.frame = CGRectIntegral(toastView.frame);
    
    [toastView addSubview:messageLabel];
    toastView.layer.cornerRadius = 7;
    toastView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
    
    return toastView;
}

- (void)showToast:(UIView *)toastView superView:(UIView *)superView duration:(double)duration
{
    if (!toastView || !superView) {
        return;
    }
    
    [VAToastManager sharedManager].toastingView = toastView;
    [superView addSubview:toastView];
    __weak typeof(self) weakSelf = self;
    //    [UIView animateWithDuration:0.2 delay:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
    //        toastView.transform = CGAffineTransformConcat(toastView.transform, CGAffineTransformMakeScale(0.8, 0.8)) ;
    //    } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.2 /*delay:0.2*/ delay:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toastView.alpha = 0;
    } completion:^(BOOL finished){
        [toastView removeFromSuperview];
        [VAToastManager sharedManager].toastingView = nil;
        
        NSMutableArray *queue = [VAToastManager sharedManager].toastQueue;
        if (queue.count > 0) {
            [queue removeObjectAtIndex:0];
            if (queue.count > 0) {
                VAToastInfo *info = [queue firstObject];
                [weakSelf showToast:info.toastView superView:info.superView duration:info.duration];
            }
        }
    }];
    //    }];
}


#pragma mark - Alert

- (void)alert:(NSDictionary *)param callback:(VAModuleCallback)callback
{
    
    NSString *message = [VAConvertUtl convertToString:param[@"message"]];
    NSString *okTitle = [VAConvertUtl convertToString:param[@"okTitle"]];
    
    if ([VAUtil isBlankString:okTitle]) {
        okTitle = @"OK";
    }
    
    [self alert:message okTitle:nil cancelTitle:okTitle defaultText:nil type:VAModalTypeAlert callback:callback];
}

#pragma mark - Confirm

- (void)confirm:(NSDictionary *)param callback:(VAModuleCallback)callback
{
    NSString *message = [VAConvertUtl convertToString:param[@"message"]];
    NSString *okTitle = [VAConvertUtl convertToString:param[@"okTitle"]];
    NSString *cancelTitle = [VAConvertUtl convertToString:param[@"cancelTitle"]];
    
    if ([VAUtil isBlankString:okTitle]) {
        okTitle = @"OK";
    }
    if ([VAUtil isBlankString:cancelTitle]) {
        cancelTitle = @"Cancel";
    }
    
    [self alert:message okTitle:okTitle cancelTitle:cancelTitle defaultText:nil type:VAModalTypeConfirm callback:callback];
}

#pragma mark - Prompt

- (void)prompt:(NSDictionary *)param callback:(VAModuleCallback)callback
{
    NSString *message = [VAConvertUtl convertToString:param[@"message"]];
    NSString *defaultValue = [VAConvertUtl convertToString:param[@"default"]];
    NSString *okTitle = [VAConvertUtl convertToString:param[@"okTitle"]];
    NSString *cancelTitle = [VAConvertUtl convertToString:param[@"cancelTitle"]];
    
    if ([VAUtil isBlankString:okTitle]) {
        okTitle = @"OK";
    }
    if ([VAUtil isBlankString:cancelTitle]) {
        cancelTitle = @"Cancel";
    }
    
    [self alert:message okTitle:okTitle cancelTitle:cancelTitle defaultText:defaultValue type:VAModalTypePrompt callback:callback];
}

#pragma mark - Private

- (void)alert:(NSString *)message okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle defaultText:(NSString *)defaultText type:(VAModalType)type callback:(VAModuleCallback)callback
{
    if (!message) {
        if (callback) {
            callback(@"Error: message should be passed correctly.");
        }
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    alertView.tag = type;
    if (type == VAModalTypePrompt) {
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.placeholder = defaultText;
    }
    objc_setAssociatedObject(alertView, &VAModalCallbackKey, [callback copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [_alertViews addObject:alertView];
    
    [VAThreadManager performOnMainThreadWithBlock:(^{
        [alertView show];
    })];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    VAModuleCallback callback = objc_getAssociatedObject(alertView, &VAModalCallbackKey);
    if (!callback) return;
    
    id result = @"";
    switch (alertView.tag) {
        case VAModalTypeAlert: {
            result = @"";
            break;
        }
        case VAModalTypeConfirm: {
            NSString *clickTitle = [alertView buttonTitleAtIndex:buttonIndex];
            result = clickTitle;
            break;
        }
        case VAModalTypePrompt: {
            NSString *clickTitle = [alertView buttonTitleAtIndex:buttonIndex];
            NSString *text= [[alertView textFieldAtIndex:0] text] ?: @"";
            result = @{ @"result": clickTitle, @"data": text };
            break;
        }
        default:
        break;
    }
    
    callback(result);
    
    [_alertViews removeObject:alertView];
}

@end
