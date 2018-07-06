//
//  VARefreshComponent.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/6.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VARefreshComponent.h"
#import "VARefreshView.h"
#import "VAComponent.h"
#import "VAComponent+private.h"
#import "VAModuleProtocol.h"

/** 刷新控件的状态 */
typedef enum {
    /** 普通闲置状态 */
    VARefreshStateIdle = 0,
    /** 松开就可以进行刷新的状态 */
    VARefreshStatePulling,
    /** 正在刷新中的状态 */
    VARefreshStateRefreshing,
    /** 即将刷新的状态 */
    VARefreshStateWillRefresh
} VARefreshState;

@interface VARefreshComponent()<VAModuleProtocol>

@property (nonatomic, assign) VARefreshState refreshState;

@end

@implementation VARefreshComponent{
    BOOL _isVertical;
    VARefreshState _refreshState;
    CGFloat _pullingPercent;  // 拉拽百分比  [0,1];
    CGFloat _pullingOffset;   // 拉拽位移
    __weak UIScrollView * _scrollView;
    //events
    BOOL _listenPullingEvent;
    BOOL _listenIdleEnvent;
    BOOL _listenRefreshEnvent;
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(ViolaInstance *)violaInstance{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:violaInstance]) {
        [self _fillRefreshCompoentEvents:events];
    }
    return self;
}


- (void)updateEventsOnComponentThread:(NSArray *)events{
    [super updateEventsOnComponentThread:events];
    [self _fillRefreshCompoentEvents:events];
}

#pragma mark - publick

-(void)contentOffsetDidChangeWithScrollView:(UIScrollView *)scrollView{
    if (_scrollView != scrollView) {
         _scrollView = scrollView;
    }
    if (_isVertical) {
        [self _contentOffsetDidChangeForVertical:scrollView];
    }else {
        //横向 todo tomqiu
    }
}



#pragma mark - js-method

- (void)va_refreshFinish{
    
    if (self.refreshState == VARefreshStateRefreshing) {
        self.refreshState = VARefreshStateIdle;
    }
}

- (dispatch_queue_t)performOnQueue{
    return dispatch_get_main_queue();
}

#pragma mark - override

- (UIView *)loadView{
    return [VARefreshView new];
}

- (void)didMoveToSupercomponent:(VAComponent *)newSupercomponent{
    [super didMoveToSupercomponent:newSupercomponent];
    [self _resetStylePostion];
}

- (void)updateStylesOnComponentThread:(NSDictionary *)styles{
    [super updateStylesOnComponentThread:styles];
    if ([styles isKindOfClass:[NSDictionary class]] && styles) {
           [self _resetStylePostion];
    }
}


#pragma mark - private

- (void)_resetStylePostion{
    BOOL vertical = self.supercomponent->_cssNode->style.flex_direction == CSS_FLEX_DIRECTION_COLUMN;
    _isVertical = vertical;
    if (vertical) {
        self->_cssNode->style.position_type = CSS_POSITION_ABSOLUTE;
        self->_cssNode->style.position[CSS_TOP] = 0;
        self->_cssNode->style.position[CSS_LEFT] = 0;
        self->_cssNode->style.position[CSS_RIGHT] = 0;
    }else {
        self->_cssNode->style.position_type = CSS_POSITION_ABSOLUTE;
        self->_cssNode->style.position[CSS_LEFT] = 0;
        self->_cssNode->style.position[CSS_TOP] = 0;
        self->_cssNode->style.position[CSS_BOTTOM] = 0;
    }
}

-(void) _contentOffsetDidChangeForVertical:(UIScrollView *)scrollView{
    if (self.refreshState == VARefreshStateRefreshing) {   // 正在刷新中就不做操作了
        return ;
    }
    CGSize size = self.componentFrame.size;
    // 跳转到下一个控制器时，contentInset可能会变
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat happendY = 0;
    if (offsetY >= happendY) return;     //向上拉就不管了
    
    // 普通 和 即将刷新 的临界点
    CGFloat normalAndPullingOffsetY = happendY - size.height;
    _pullingOffset =  (happendY - offsetY);
    _pullingPercent = _pullingOffset / size.height;
    if (scrollView.isDragging) { // 如果正在拖拽
        if (self.refreshState == VARefreshStateIdle && offsetY < normalAndPullingOffsetY) {
            // 转为即将刷新状态
            self.refreshState = VARefreshStatePulling;
        } else if (self.refreshState == VARefreshStatePulling && offsetY >= normalAndPullingOffsetY) {
            // 转为普通状态
            self.refreshState = VARefreshStateIdle;
        }
    } else if (self.refreshState == VARefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
          self.refreshState = VARefreshStateRefreshing;
    }
    
}

- (void)setRefreshState:(VARefreshState)refreshState{
    if (_refreshState == refreshState) {
        return ;
    }
    if (_isVertical) {
        [self _stateDidChangForVerticalWithState:refreshState];
    }else {
//        [self stateDidChangForHorizonalWithState:state];
    }
    _refreshState = refreshState;
}


-(void) _stateDidChangForVerticalWithState:(VARefreshState)state{
    // 根据状态做事情
    CGSize size = self.componentFrame.size;
    if (state == VARefreshStateIdle && self.refreshState == VARefreshStateRefreshing) {
        // 恢复inset和offset
        [UIView animateWithDuration:0.3 animations:^{
            UIEdgeInsets insets = _scrollView.contentInset;
            insets.top = insets.top - size.height;
            _scrollView.contentInset = insets;
        } completion:^(BOOL finished) {
            _pullingPercent = 0.0;
            _pullingOffset = 0.0;
            if (_listenIdleEnvent) {
                [self _fireRefreshComponentEventWithName:@"idle" extralParam:nil];
                
            }
        }];
    } else if (state == VARefreshStateRefreshing) {
        UIEdgeInsets insets = _scrollView.contentInset;
        insets.top =  size.height;
        [UIView animateWithDuration:0.3 animations:^{
            // 增加滚动区域
            _scrollView.contentInset = insets;
            //设置滚动位置
            CGPoint contentOff = _scrollView.contentOffset;
            contentOff.y = - insets.top;
            _scrollView.contentOffset = contentOff;
        } completion:^(BOOL finished) {
            //开始刷新
            if (_listenRefreshEnvent) {
                 [self _fireRefreshComponentEventWithName:@"refresh" extralParam:nil];
            }
        }];

    }else if(state == VARefreshStatePulling){
        if (_listenPullingEvent) {
            [self _fireRefreshComponentEventWithName:@"pulling" extralParam:nil];
        }
    }else if(state == VARefreshStateIdle){
        if (_listenIdleEnvent) {
             [self _fireRefreshComponentEventWithName:@"idle" extralParam:nil];
        }

    }
        
    
    
}

- (void)_fireRefreshComponentEventWithName:(NSString *)name extralParam:(NSDictionary *)extralParam{
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    param[@"size"] = [VAConvertUtl convertToDictionaryWithSize:self.componentFrame.size];
    if([extralParam isKindOfClass:[NSDictionary class]] && extralParam.count){
        [param addEntriesFromDictionary:extralParam];
    }
    [self fireEventWithName:name params:param];
}

#define VA_FILL_EVENTS(key,prop) \
if([events containsObject:@#key]){\
prop = true;\
}
- (void)_fillRefreshCompoentEvents:(NSArray *)events{
    events = [events isKindOfClass:[NSArray class]] ? events : nil;
    VA_FILL_EVENTS(pulling, _listenPullingEvent);
    VA_FILL_EVENTS(idle, _listenIdleEnvent);
    VA_FILL_EVENTS(refresh, _listenRefreshEnvent);
}
@end
