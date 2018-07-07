//
//  VAScrollerComponent.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/2.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAScrollerComponent.h"
#import "VAComponent+private.h"
#import "VAConvertUtl.h"
#import "VAWrapView.h"
#import "VAThreadManager.h"
#import "VADefine.h"
#import "VAComponent.h"
#import "VARefreshComponent.h"
@interface VAScrollerComponent()<UIScrollViewDelegate>
@property (nonatomic, assign)   BOOL loadMoreing;
@property (nonatomic, assign)   CGPoint lastContentOffset;
@property (nonatomic, assign)   CGPoint fireScollLastContentOffset;
@end

@implementation VAScrollerComponent{

    //attr
    BOOL _showScrollerIndicator;
    BOOL _bouncesEnable;//滚动弹性
    BOOL _scrollEnable;//能否滑动
    BOOL _pagingEnable;//分页
    CGFloat _preloadDistance;//预加载底部距离
    CGFloat _scrollMinOffset;//滚动最小距离 默认为5
    //events
    BOOL _listenLoadMoreEvent;//
    BOOL _listenScrollEvent;
    BOOL _listentScrollEnd;

    css_node_t *_scrollerCSSNode;
    CGSize _contentSize;//
    UIScrollView * _scrollView;
    __weak VARefreshComponent * _refreshComponent;
    
    
    BOOL _isVerticoalScrollDirection;
    
  
}
#pragma mark - override

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(ViolaInstance *)violaInstance{
    if(self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:violaInstance]){
        //
        [self _fillScrollerComponentAtts:attributes init:true];
        [self _fillScrollerComponentStyles:attributes init:true];
        [self _fillScrollerEvents:events];
        _scrollerCSSNode = new_css_node();
        
       
    }
    return self;
}

- (UIView *)loadView{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    return [[VAWrapView alloc] initWithView:_scrollView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _scrollView.contentSize = _contentSize;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self _syncAttrToScrollView];
    
}

- (void)didInsertSubcomponent:(VAComponent *)subcomponent atIndex:(NSInteger)index{
    [super didInsertSubcomponent:subcomponent atIndex:index];
    if ([subcomponent isKindOfClass:[VARefreshComponent class]]) {
        _refreshComponent = (VARefreshComponent *)subcomponent;
    }

}


- (void)updateComponentOnComponentThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events{
    [super updateComponentOnComponentThreadWithAttributes:attributes styles:styles events:events];
    [self _fillScrollerComponentStyles:styles init:false];
    [self _fillScrollerComponentAtts:attributes init:false];
    [self _fillScrollerEvents:events];
}

- (void)updateComponentOnMainThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events{
    [super updateComponentOnMainThreadWithAttributes:attributes styles:styles events:events];
    [self _syncAttrToScrollView];
}


- (void)layoutDidEnd{
    [super layoutDidEnd];
    _scrollView.contentSize = _contentSize;
}
- (void)componentFrameWillChange{
    [super componentFrameWillChange];
    if(!CGRectEqualToRect(_componentFrame , CGRectZero) && ![self isNeedsLayout]){
        [self setNeedsLayout];
    }
}


#pragma mark - private
#define VA_FILL_SCROLLL_ATTRS(key,prop,method,defaultValue) \
value = atts[@#key];\
if(value){\
prop = [VAConvertUtl method:value];\
needUpdate = YES;\
}else if(init){\
prop = defaultValue;\
}
- (void)_fillScrollerComponentStyles:(NSDictionary *)styles init:(BOOL)init{
    if(init){
        if(isnan(self->_cssNode->style.flex) || self->_cssNode->style.flex == 0){
            self->_cssNode->style.flex = 1;
        }
    }
    if(self->_cssNode->style.flex_direction == CSS_FLEX_DIRECTION_COLUMN){
        _isVerticoalScrollDirection = true;
    }else {
        _isVerticoalScrollDirection = false;
    }
}

- (BOOL)_fillScrollerComponentAtts:(NSDictionary *)atts init:(BOOL)init{
    atts = [atts isKindOfClass:[NSDictionary class]] ? atts: nil;
    BOOL needUpdate = false;
    id value;
    VA_FILL_SCROLLL_ATTRS(showScrollerIndicator, _showScrollerIndicator, convertToBOOL, true);
    VA_FILL_SCROLLL_ATTRS(bouncesEnable, _bouncesEnable, convertToBOOL, true);
    VA_FILL_SCROLLL_ATTRS(scrollEnable, _scrollEnable, convertToBOOL, true);
    VA_FILL_SCROLLL_ATTRS(pagingEnable, _pagingEnable, convertToBOOL, false);
    VA_FILL_SCROLLL_ATTRS(preloadDistance, _preloadDistance, convertToFloatWithPixel, 200);
    VA_FILL_SCROLLL_ATTRS(scrollMinOffset, _scrollMinOffset, convertToFloatWithPixel, 5);
    return needUpdate;
}
#define VA_FILL_SCROLLL_EVENTS(key,prop) \
if([events containsObject:@#key]){\
    prop = true;\
}
- (void)_fillScrollerEvents:(NSArray *)events{
    events = [events isKindOfClass:[NSArray class]] ? events : nil;
    VA_FILL_SCROLLL_EVENTS(loadMore, _listenLoadMoreEvent);
    VA_FILL_SCROLLL_EVENTS(scroll, _listenScrollEvent);
    VA_FILL_SCROLLL_EVENTS(scrollEnd, _listentScrollEnd);
}

#pragma mark mark

- (void)_syncAttrToScrollView{
    if(_scrollView.scrollEnabled != _scrollEnable){
        _scrollView.scrollEnabled = _scrollEnable;
    }
    if(_scrollView.pagingEnabled != _pagingEnable){
        _scrollView.pagingEnabled = _pagingEnable;
    }
    if(_scrollView.bounces != _bouncesEnable){
        _scrollView.bounces = _bouncesEnable;
    }
    if(_scrollView.showsVerticalScrollIndicator != _showScrollerIndicator){
        _scrollView.showsVerticalScrollIndicator = _showScrollerIndicator;
    }
    if(_scrollView.showsHorizontalScrollIndicator != _showScrollerIndicator){
        _scrollView.showsHorizontalScrollIndicator = _showScrollerIndicator;
    }
    if(_bouncesEnable){
        _scrollView.alwaysBounceVertical = _isVerticoalScrollDirection;
        _scrollView.alwaysBounceHorizontal = !_isVerticoalScrollDirection;
    }
    
}

#pragma mark - js
//js响应了loadMore事件结束时 回调该api
- (void)va_loadMoreFinish{
    kBlockWeakSelf;
   
    [VAThreadManager performOnComponentThreadWithBlock:^{
        weakSelf.loadMoreing = false;
        _lastContentOffset = CGPointZero;
        [weakSelf _fireLoadMoreEventIfNeed];
    } afterDelay:0.1];
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self _fireLoadMoreEventIfNeed];
    [self _fireScrollEventIfNeed];
    _lastContentOffset = scrollView.contentOffset;
    if (_refreshComponent) {
        [_refreshComponent contentOffsetDidChangeWithScrollView:scrollView];
    }
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _fireScollLastContentOffset = CGPointMake(MAXFLOAT, MAXFLOAT);
    [self _fireScrollEventIfNeed];
    [self _fireLoadMoreEventIfNeed];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _fireScollLastContentOffset = CGPointMake(MAXFLOAT, MAXFLOAT);
    [self _fireScrollEventIfNeed];
    [self _fireScrollEndEventIfNeed];
}

#pragma mark - private

- (void)_fireLoadMoreEventIfNeed{
    if(!_listenLoadMoreEvent) return;
    if (!_loadMoreing) {
        CGPoint contentOffset = _scrollView.contentOffset;
        //纵向布局
        if (_isVerticoalScrollDirection) {
            if (contentOffset.y >= 0 && contentOffset.y > _lastContentOffset.y &&( _scrollView.contentSize.height - (contentOffset.y + _scrollView.bounds.size.height)) < _preloadDistance ) {
                _loadMoreing = true;
                [self _fireScollerEventWithName:@"loadMore" extralParam:nil];
            }
        }else {
            if (contentOffset.x >= 0 && contentOffset.x > _lastContentOffset.x &&( _scrollView.contentSize.width - (contentOffset.x + _scrollView.bounds.size.width)) < _preloadDistance ) {
                _loadMoreing = true;
                [self _fireScollerEventWithName:@"loadMore" extralParam:nil];
            }
        }
    }
}


- (void)_fireScrollEventIfNeed{
    if (_listenScrollEvent) {
        if (_isVerticoalScrollDirection) {
            if(fabs(_fireScollLastContentOffset.y - _scrollView.contentOffset.y) < _scrollMinOffset) return ;
        }else {
            if(fabs(_fireScollLastContentOffset.x - _scrollView.contentOffset.x) < _scrollMinOffset) return ;
        }
        _fireScollLastContentOffset = _scrollView.contentOffset;
        [self _fireScollerEventWithName:@"scroll" extralParam:@{@"lastContentOffset":[VAConvertUtl convertToDictionaryWithPoint:_lastContentOffset]}];
    }
}

- (void)_fireScrollEndEventIfNeed{
    if (_listentScrollEnd) {
        [self _fireScollerEventWithName:@"scrollEnd" extralParam:nil];
    }
}


//scroller的事件发送都是调用这个api
- (void)_fireScollerEventWithName:(NSString *)name extralParam:(NSDictionary *)extralParam{
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    param[@"contentSize"] = [VAConvertUtl convertToDictionaryWithSize:_scrollView.contentSize];
    param[@"contentOffset"] = [VAConvertUtl convertToDictionaryWithPoint:_scrollView.contentOffset];
    param[@"frame"] = [VAConvertUtl convertToDictionaryWithRect:_scrollView.frame];
    if([extralParam isKindOfClass:[NSDictionary class]] && extralParam.count){
        [param addEntriesFromDictionary:extralParam];
    }
    [self fireEventWithName:name params:param];
}



#pragma mark - layout
static int cssNode_scroller_childrenCount(void * context){
    VAScrollerComponent *component = (__bridge VAScrollerComponent *)context;
    return [component _realChildrenCountForCSSNode];
}

//重写基类方法
- (int)_getChildrenCountForCSSNode{
    if (_subcomponents.count && [_subcomponents.firstObject isKindOfClass:[NSDictionary class]]) {
        
    }
    return 0;
}

//真正子节点个数
- (int)_realChildrenCountForCSSNode{
    return [super _getChildrenCountForCSSNode];
}




- (void)_syncCSSNodeLayoutWithDirtyComponents:(NSMutableArray *)dirtyComponents{
    [self _layoutSubCSSNodesWithDirtyComponents:dirtyComponents];
    [super _syncCSSNodeLayoutWithDirtyComponents:dirtyComponents];
}

- (void)_layoutSubCSSNodesWithDirtyComponents:(NSMutableArray *)dirtyComponents{
    if ([self isNeedsLayout]) {
        memcpy(_scrollerCSSNode, self->_cssNode, sizeof(css_node_t));
        _scrollerCSSNode->children_count = cssNode_scroller_childrenCount;
        
        _scrollerCSSNode->style.position[CSS_LEFT] = 0;
        _scrollerCSSNode->style.position[CSS_TOP] = 0;
        
        if (_scrollerCSSNode->style.flex_direction == CSS_FLEX_DIRECTION_COLUMN) {
            _scrollerCSSNode->style.dimensions[CSS_WIDTH] = _cssNode->layout.dimensions[CSS_WIDTH] - _contentEdge.left - _contentEdge.right;
            _scrollerCSSNode->style.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
        } else {
            _scrollerCSSNode->style.dimensions[CSS_HEIGHT] = _cssNode->layout.dimensions[CSS_HEIGHT]  - _contentEdge.top - _contentEdge.bottom;
            _scrollerCSSNode->style.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
        }
        
        _scrollerCSSNode->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
        _scrollerCSSNode->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
        
        layoutNode(_scrollerCSSNode, CSS_UNDEFINED, CSS_UNDEFINED, CSS_DIRECTION_INHERIT);
        
        CGSize size = {
            VARoundValue(_scrollerCSSNode->layout.dimensions[CSS_WIDTH]),
            VARoundValue(_scrollerCSSNode->layout.dimensions[CSS_HEIGHT])
        };
        if (!CGSizeEqualToSize(size, _contentSize)) {
            // content size
            _contentSize = size;
            [dirtyComponents addObject:self];
        }
        _scrollerCSSNode->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
        _scrollerCSSNode->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
    }
}




@end
