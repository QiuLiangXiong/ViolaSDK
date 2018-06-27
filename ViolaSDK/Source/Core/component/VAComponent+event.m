//
//  VAComponent+event.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/6/25.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAComponent+event.h"
#import "VAComponent.h"
#import "VADefine.h"
#import "VAComponent+private.h"
#import "VABridgeManager.h"
#import "ViolaInstance.h"
@implementation VAComponent (event)
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)_initEvents:(NSMutableArray *)events{
    [self __updateEventsWithEvents:events];
}

- (void)_updateEventsOnComponentThread:(NSArray *)events{
    VAAssertComponentThread();
    [self __updateEventsWithEvents:events];
    [self updateEventsOnComponentThread:events];
}
- (void)_updateEventsOnMainThread:(NSArray *)events{
    VAAssertMainThread();
    [self _syncTouchEventsToView];//同步
    [self updateEventsOnMainThread:events];
}


- (void)__updateEventsWithEvents:(NSArray *)events{
    VAAssertComponentThread();
    int count = 0;
    if ([events isKindOfClass:[NSArray class]] && events.count) {
        do {
            if ([events containsObject:@"click"]) {
                _singleClickEnable = true;
                if (++count >= events.count)break;
            }
            if ([events containsObject:@"doubleClick"]) {
                _doubleClickEnable = true;
                 if (++count >= events.count)break;
            }
            if ([events containsObject:@"longPress"]) {
                _longPressEnable = true;
                 if (++count >= events.count)break;
            }
            if ([events containsObject:@"swipeLeft"]) {
                _swipeLeftEnable = true;
                 if (++count >= events.count)break;
            }
            if ([events containsObject:@"swipeRight"]) {
                _swipeRightEnable = true;
                 if (++count >= events.count)break;
            }
            if ([events containsObject:@"swipeTop"]) {
                _swipeTopEnable = true;
                 if (++count >= events.count)break;
            }
            if ([events containsObject:@"swipeBottom"]) {
                _swipeBottomEnable = true;
                if (++count >= events.count)break;
            }
            if ([events containsObject:@"pan"]) {
                _panEnable = true;
            }
        } while (0);
     
    }
}


- (void)_syncTouchEventsToView{
    VAAssertMainThread();
    if ([self isViewLoaded]) {
        
        BOOL needResumeUserInteration = false;
        //单击
        if (_singleClickEnable) {
            if (!_tapGesture) {
                _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleClickWithSender:)];
            }
            if (![_view.gestureRecognizers containsObject:_tapGesture]) {
                [_view addGestureRecognizer:_tapGesture];
                needResumeUserInteration = true;

            }
        }else if(_tapGesture){
            [_view removeGestureRecognizer:_tapGesture];
            _tapGesture = nil;
        }
        
        //双击
        if (_doubleClickEnable) {
            if (!_doubleTapGesture) {
                _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleClickWithSender:)];
                _doubleTapGesture.numberOfTapsRequired = 2;
                if (_tapGesture) {
                    [_tapGesture requireGestureRecognizerToFail:_doubleTapGesture];
                }
            }
            if (![_view.gestureRecognizers containsObject:_doubleTapGesture]) {
                [_view addGestureRecognizer:_doubleTapGesture];
                 needResumeUserInteration = true;
            }
        }else if(_doubleTapGesture){
            [_view removeGestureRecognizer:_doubleTapGesture];
            _doubleTapGesture = nil;
        }
        
        //长按
        if (_longPressEnable) {
            if (!_longPressGesture) {
                _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressWithSender:)];
            }
            if (![_view.gestureRecognizers containsObject:_longPressGesture]) {
                [_view addGestureRecognizer:_longPressGesture];
                needResumeUserInteration = true;
            }
        }else if(_longPressGesture){
            [_view removeGestureRecognizer:_longPressGesture];
            _longPressGesture = nil;
        }
        //右边轻扫
        if (_swipeLeftEnable) {
            if (!_swipeLeftGesture) {
                _swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeftWithSender:)];
                _swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            }
            if (![_view.gestureRecognizers containsObject:_swipeLeftGesture]) {
                [_view addGestureRecognizer:_swipeLeftGesture];
                needResumeUserInteration = true;
            }
        }else if(_swipeLeftGesture){
            [_view removeGestureRecognizer:_swipeLeftGesture];
            _swipeLeftGesture = nil;
        }
        //左边轻扫
        if (_swipeRightEnable) {
            if (!_swipeRightGesture) {
                _swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRightWithSender:)];
                _swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
            }
            if (![_view.gestureRecognizers containsObject:_swipeRightGesture]) {
                [_view addGestureRecognizer:_swipeRightGesture];
                needResumeUserInteration = true;
            }
        }else if(_swipeRightGesture){
            [_view removeGestureRecognizer:_swipeRightGesture];
            _swipeRightGesture = nil;
        }
        //上边轻扫
        if (_swipeTopEnable) {
            if (!_swipeTopGesture) {
                _swipeTopGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeTopWithSender:)];
                _swipeTopGesture.direction = UISwipeGestureRecognizerDirectionUp;
            }
            if (![_view.gestureRecognizers containsObject:_swipeTopGesture]) {
                [_view addGestureRecognizer:_swipeTopGesture];
                needResumeUserInteration = true;
            }
        }else if(_swipeTopGesture){
            [_view removeGestureRecognizer:_swipeTopGesture];
            _swipeTopGesture = nil;
        }
        //上边轻扫
        if (_swipeBottomEnable) {
            if (!_swipeBottomGesture) {
                _swipeBottomGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeBottomWithSender:)];
                _swipeBottomGesture.direction = UISwipeGestureRecognizerDirectionDown;
            }
            if (![_view.gestureRecognizers containsObject:_swipeBottomGesture]) {
                [_view addGestureRecognizer:_swipeBottomGesture];
                needResumeUserInteration = true;
            }
        }else if(_swipeBottomGesture){
            [_view removeGestureRecognizer:_swipeBottomGesture];
            _swipeBottomGesture = nil;
        }
        //pan手势
        if (_panEnable) {
            if (!_panGesture) {
                _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanWithSender:)];
            }
            if (![_view.gestureRecognizers containsObject:_panGesture]) {
                [_view addGestureRecognizer:_panGesture];
                needResumeUserInteration = true;
            }
        }else if(_panGesture){
            [_view removeGestureRecognizer:_panGesture];
            _panGesture = nil;
        }
        
        
        if (needResumeUserInteration) {
            _view.userInteractionEnabled = true;
            if (_touchEnable && [_touchEnable boolValue] == false) {
                _view.userInteractionEnabled = false;
            }
        }
    }
}

#pragma mark - action

- (void)onSingleClickWithSender:(id)sender{
    [self _fireEventWithName:@"click" extralParam:nil];
    
}
- (void)onDoubleClickWithSender:(id)sender{
    [self _fireEventWithName:@"doubleClick" extralParam:nil];
}

- (void)onLongPressWithSender:(UILongPressGestureRecognizer *)sender{
    NSString * state = nil;
    if (sender.state == UIGestureRecognizerStateBegan){
        state = @"start";
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        state = @"end";
    }
    if (state) {
        [self _fireEventWithName:@"longPress" extralParam:@{@"state":state}];
    }
}
- (void)onSwipeTopWithSender:(id)sender{
    [self _fireEventWithName:@"swipeTop" extralParam:nil];
}

- (void)onSwipeBottomWithSender:(id)sender{
    [self _fireEventWithName:@"swipeBottom" extralParam:nil];
}

- (void)onSwipeLeftWithSender:(id)sender{
    [self _fireEventWithName:@"swipeLeft" extralParam:nil];
}
- (void)onSwipeRightWithSender:(id)sender{
    [self _fireEventWithName:@"swipeRight" extralParam:nil];
}

- (void)onPanWithSender:(UIPanGestureRecognizer *)panGR{
    
    NSString * state = @"";
    if (panGR.state == UIGestureRecognizerStateBegan) {
        state = @"begin";
    } else if (panGR.state == UIGestureRecognizerStateEnded) {
        state = @"end";
    } else if (panGR.state == UIGestureRecognizerStateChanged) {
        state = @"change";
    }else if(panGR.state == UIGestureRecognizerStateCancelled){
        state = @"cancel";
    }
    CGPoint absoluteLoacation = [panGR locationInView:_vaInstance.rootView];
    CGPoint translation = [panGR translationInView:self.view];
    CGPoint vilocity = [panGR velocityInView:self.view];
    
    NSMutableDictionary * locationDic = [[NSMutableDictionary alloc] init];
    locationDic[@"x"] = [[@(absoluteLoacation.x) stringValue] stringByAppendingString:@"dp"];
    locationDic[@"y"] =[[@(absoluteLoacation.y) stringValue] stringByAppendingString:@"dp"];
    
    NSMutableDictionary * translationDic = [[NSMutableDictionary alloc] init];
    translationDic[@"x"] = [[@(translation.x) stringValue] stringByAppendingString:@"dp"];
    translationDic[@"y"] =[[@(translation.y) stringValue] stringByAppendingString:@"dp"];
    
    NSMutableDictionary * vilocityDic = [[NSMutableDictionary alloc] init];
    vilocityDic[@"x"] = @(vilocity.x);
    vilocityDic[@"y"] = @(vilocity.y);
    
    if (state) {
        [self _fireEventWithName:@"pan" extralParam:@{@"state":state,@"location":locationDic,@"translation":translationDic,@"vilocityDic":vilocityDic}];
    }

    
}

#pragma mark - private

- (void)_fireEventWithName:(NSString *)name param:(NSDictionary *)param{
    [[VABridgeManager shareManager] fireEventWithIntanceID:_vaInstance.instanceId ref:_ref type:name params:param domChanges:nil];
}

- (void)_fireEventWithName:(NSString *)name extralParam:(NSDictionary *)param{
    NSMutableDictionary *frameInfo = [[NSMutableDictionary alloc] init];
    CGRect frame = [self.view.superview convertRect:self.view.frame toView:self.view.window];
    frameInfo[@"x"] = [[@(frame.origin.x) stringValue] stringByAppendingString:@"dp"];
    frameInfo[@"y"] = [[@(frame.origin.y) stringValue] stringByAppendingString:@"dp"];
    frameInfo[@"width"] = [[@(frame.size.width) stringValue] stringByAppendingString:@"dp"];
    frameInfo[@"height"] = [[@(frame.size.height) stringValue] stringByAppendingString:@"dp"];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"frame":frameInfo}];
    if (param) {
        [params addEntriesFromDictionary:param];
    }
    [self _fireEventWithName:name param:params];
}

@end
