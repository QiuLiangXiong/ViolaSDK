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

@implementation VARefreshComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(ViolaInstance *)violaInstance{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:violaInstance]) {
        
    }
    return self;
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

@end
