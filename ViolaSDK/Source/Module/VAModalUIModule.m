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
