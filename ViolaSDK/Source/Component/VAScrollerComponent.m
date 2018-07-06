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
@interface VAScrollerComponent()<UIScrollViewDelegate>
@property (nonatomic, assign)   BOOL loadMoreing;
@property (nonatomic, assign)   CGPoint lastContentOffset;
@end

@implementation VAScrollerComponent{

    //attr
    BOOL _showScrollerIndicator;
    BOOL _bouncesEnable;//滚动弹性
    BOOL _scrollEnable;//能否滑动
    BOOL _pagingEnable;//分页
    CGFloat _preloadDistance;//预加载底部距离
    //events
    BOOL _listenLoadMoreEvent;//
    BOOL _listenScrollEvent;
    BOOL _listentScrollEnd;
    BOOL _listentContentSizeChangeEvent;
    
    css_node_t *_scrollerCSSNode;
    CGSize _contentSize;//
    UIScrollView * _scrollView;
    
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
    _scrollView.contentSize = _contentSize;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self _syncAttrToScrollView];
    
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
    VA_FILL_SCROLLL_EVENTS(contentSizeChange, _listentContentSizeChangeEvent);
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
    } afterDelay:0.1];
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //
    //
    //
    [self _fireLoadMoreEventIfNeed];
    [self _fireScrollEventIfNeed];
    
    
    _lastContentOffset = scrollView.contentOffset;
    
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
                //会传contentHeight offset 和距离底部的距离 等参数
                [self fireEventWithName:@"loadMore" params:@{}];
            }
        }else {
            if (contentOffset.x >= 0 && contentOffset.x > _lastContentOffset.x &&( _scrollView.contentSize.width - (contentOffset.x + _scrollView.bounds.size.width)) < _preloadDistance ) {
                _loadMoreing = true;
                //会传contentHeight offset 和距离底部的距离 等参数
                [self fireEventWithName:@"loadMore" params:@{}];
            }
        }
    }
}

- (void) _fireScrollEventIfNeed{
    if (_listenScrollEvent) {
        
        if(fabs(_lastContentOffset.y - _scrollView.contentOffset.y) < 50) return ;
        
        NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
        param[@"contentSize"] = [VAConvertUtl convertToDictionaryWithSize:_scrollView.contentSize];
        param[@"contentOffset"] = [VAConvertUtl convertToDictionaryWithPoint:_scrollView.contentOffset];
        param[@"frame"] = [VAConvertUtl convertToDictionaryWithRect:_scrollView.frame];
        [self fireEventWithName:@"scroll" params:param];
    }
    
}


#pragma mark - layout
static int cssNode_scroller_childrenCount(void * context){
    VAScrollerComponent *component = (__bridge VAScrollerComponent *)context;
    return [component _realChildrenCountForCSSNode];
}

//重写基类方法
- (int)_getChildrenCountForCSSNode{
    return 0;
}


//真正子节点个数
- (int)_realChildrenCountForCSSNode{
    return [super _getChildrenCountForCSSNode];
}

- (void)_syncCSSNodeLayoutWithDirtyComponents:(NSMutableArray *)dirtyComponents{
    //
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
    
    
    
    [super _syncCSSNodeLayoutWithDirtyComponents:dirtyComponents];
}




@end
