//
//  VAWrapView.m
//  ViolaSDK
//
//  Created by QLX on 2018/7/3.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAWrapView.h"
#import "VAComponent.h"

@implementation VAWrapView{
    UIView * _rootView;
}

- (instancetype)initWithView:(UIView *)view{
    if(self = [self init]){
        _rootView = view;
        [self addSubview:view];
    }
    return self;
}
//
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index{
   // [super insertSubview:view atIndex:index];
    [_rootView insertSubview:view atIndex:index];
}



- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    UIEdgeInsets contentEdge = self.va_component.contentEdge;
    CGSize size = frame.size;
    _rootView.frame = CGRectMake(contentEdge.left, contentEdge.top,fmax(0, size.width - contentEdge.left - contentEdge.right) , fmax(0, size.height - contentEdge.top - contentEdge.bottom));
}







@end
