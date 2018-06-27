//
//  VAComponent+view.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/6/25.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAComponent+view.h"
#import "VAComponent+private.h"
#import "VADefine.h"
#import "VAConvertUtl.h"
#import "ViolaInstance.h"

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@interface VAComponent()


@end

@implementation VAComponent (view)


#pragma mark - init

- (void)_initViewPropWithStyles:(NSDictionary *)styles{
    styles = [styles isKindOfClass:[NSDictionary class]] ? styles : nil;
    _visibility = [VAConvertUtl convertToBOOLWithVisibilityValue:styles[@"visibility"] defaultValue:YES];
    _opacity = [VAConvertUtl convertToFloat:styles[@"opacity"] defaultValue:1.0f];
    _clipToBounds =  [VAConvertUtl convertToBOOLWithClipValue:styles[@"overflow"] defaultValue:NO];
    _backgroundColor = [VAConvertUtl convertToColor:styles[@"backgroundColor"] defaultValue:[UIColor clearColor]];
    _positionType = [VAConvertUtl converToPosition:styles[@"position"] defaultValue:(VALayoutPositionRelative)];
    //    _transform = styles[@"transform"] || styles[@"transformOrigin"] ?//todo tomqiu  transform //这个一般和动画相关
     //todo tomqiu  transform and border
}


- (void)_updateViewPropWithStyles:(NSDictionary *)styles{
    VAAssertMainThread();
    if (styles[@"visibility"]) {
        _visibility = [VAConvertUtl convertToBOOLWithVisibilityValue:styles[@"visibility"]];
        _view.hidden = !_visibility;
    }
    if (styles[@"opacity"]) {
        _opacity = [VAConvertUtl convertToFloat:styles[@"opacity"]];
        _view.alpha = _opacity;
    }
    if (styles[@"overflow"]) {
        _clipToBounds = [VAConvertUtl convertToBOOLWithClipValue:styles[@"overflow"]];
        _view.clipsToBounds = _clipToBounds;
    }
    
    if (styles[@"backgroundColor"]) {
        _backgroundColor = [VAConvertUtl convertToColor:styles[@"backgroundColor"]];
        _view.backgroundColor = _backgroundColor;
    }
    
    if (styles[@"position"]) {
        _positionType = [VAConvertUtl converToPosition:styles[@"position"]];
    }
    //todo tomqiu  transform and border
}



#pragma mark Public

- (UIView *)loadView{
    return [[UIView alloc] init];
}

- (BOOL)isViewLoaded{
    return _view != nil;
}

- (void)insertSubview:(VAComponent *)subcomponent atIndex:(NSUInteger)index{
    VAAssertMainThread();
    //todo tomqiu lazyCreateView逻辑
    
    VAAssertReturn(subcomponent, @"can't be nil");
    if(subcomponent.view.superview){
      [subcomponent.view removeFromSuperview];//有父亲先删除
    }
    [self.view insertSubview:subcomponent.view atIndex:index];
}

- (void)moveToSuperview:(VAComponent *)supercomponent atIndex:(NSUInteger)index{
    VAAssertMainThread();
    [self removeFromSuperview];
    [supercomponent insertSubview:self atIndex:index];
}

- (void)removeFromSuperview{
    VAAssertMainThread();
    if ([self isViewLoaded]) {
        [self.view removeFromSuperview];
    }
}
//component view 变化

- (void)componentFrameWillChange{
    
}

- (void)componentFrameDidChange{
     //todo tomqiu
    kBlockWeakSelf;
    [_vaInstance.componentController addTaskToMainQueueOnComponentThead:^{
        [weakSelf _componentFrameDidChange];
    }];
}




#pragma mark Property

- (UIView *)view{
   
    if ([self isViewLoaded]) {
        return _view;
    } else {
        VAAssertMainThread();
        
        [self viewWillLoad];
        

        
        _view = [self loadView];
        _view.frame = _componentFrame;
        _view.hidden = !_visibility;
        _view.clipsToBounds = _clipToBounds;
        _view.backgroundColor = _backgroundColor;
        _view.alpha = _opacity;
//        if (![self _needsDrawBorder]) {
//            _layer.borderColor = _borderTopColor.CGColor;
//            _layer.borderWidth = _borderTopWidth;
//            [self _resetNativeBorderRadius];
//            _layer.opacity = _opacity;
//            _view.backgroundColor = _backgroundColor;
//        }
    
//        if (_transform) {
//            [_transform applyTransformForView:_view];
//        }
        
//        if (_boxShadow) {
//            [self configBoxShadow:_boxShadow];
//        }
        
        _view.va_component = self;
        [self viewDidLoad];//viewdidload
        return _view;
    }
}


#pragma mark - private

- (void)_componentFrameDidChange{
    self.view.frame = _componentFrame;
    //圆角
}



@end
