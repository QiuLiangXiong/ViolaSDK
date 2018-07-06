//
//  VARefreshView.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/6.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VARefreshView.h"
#import "VAComponent.h"
#import "VAComponent+private.h"

@implementation VARefreshView

- (void)setFrame:(CGRect)frame{
    if (!CGRectEqualToRect(CGRectZero, frame)) {
        BOOL vertical = self.va_component.supercomponent->_cssNode->style.flex_direction == CSS_FLEX_DIRECTION_COLUMN;
        if (vertical) {
            frame = CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height);
        }else {
            frame = CGRectMake(-frame.size.width,0, frame.size.width, frame.size.height);
        }
    }
    [super setFrame:frame];
}

@end
