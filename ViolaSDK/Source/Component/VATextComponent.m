//
//  VATextComponent.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/6/29.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VATextComponent.h"
#import "RIJAsyncLabel.h"
#import "VAConvertUtl.h"
#import "VADefine.h"
#import "ViolaInstance.h"
#import "VAComponent+private.h"
#define VA_FILL_TEXT_STYLE(key,prop,method,defaultValue) \
value = styles[@#key];\
if(value){\
prop = [VAConvertUtl method:value];\
needUpdate = YES;\
}else if(isInit){\
prop = defaultValue;\
}
@interface VATextComponent()



@end

@implementation VATextComponent{
    RIJAsyncLabel * _label;
    NSString *_text;
    NSMutableAttributedString * _textAttributedString;
    
    //css text style
    UIColor *_color;
    NSString *_fontFamily;
    CGFloat _fontSize;
    CGFloat _fontWeight;
    VATextStyle _fontStyle;//todo tomqiu
    NSUInteger _maxLines;
    NSTextAlignment _textAlign;
    VATextDecoration _textDecoration;
    NSLineBreakMode _lineBreakMode;
    CGFloat _lineSpacing;
    CGFloat _lineHeight;
    CGFloat _letterSpacing;
    
    CGFloat _lineHeightOffset;//修正RIJAsyncLabel
    
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(ViolaInstance *)violaInstance{
    if(self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:violaInstance]){
        
        
        
        [self _fillTextComponentAttr:attributes];
        [self _fillTextComponentStyles:styles isInit:true];
        _textAttributedString = [self _buildNewAttributedString];
    }
    return self;
}



#pragma mark - override

- (UIView *)loadView{
    UIView * view = [[UIView alloc] init];;
    _label = [[RIJAsyncLabel alloc] init];
    [view addSubview:_label];
    return view;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview ];
    [self _updateLableAsyncRender];
    _label.drawAtPoint = CGPointMake(0, _lineHeightOffset);
    _label.attributedText = _textAttributedString;
}

- (void)componentFrameDidChangeOnMainQueue{
    [super componentFrameDidChangeOnMainQueue ];
    CGSize size = self.view.bounds.size;
    _label.frame = CGRectMake(self.contentEdge.left, self.contentEdge.top,size.width - self.contentEdge.left - self.contentEdge.right,size.height - self.contentEdge.top - self.contentEdge.bottom);
}


- (void)insertSubview:(VAComponent *)subcomponent atIndex:(NSUInteger)index{
    return ;//不支持添加子节点
}

- (void)updateComponentOnComponentThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events{
    [super updateComponentOnComponentThreadWithAttributes:attributes styles:styles events:events];
    
    BOOL isUpdateAtts = [self _fillTextComponentAttr:attributes];
    BOOL isUpdateStyles = [self _fillTextComponentStyles:styles isInit:false];
    if(isUpdateAtts || isUpdateStyles){
        _textAttributedString = [self _buildNewAttributedString];
        [self setNeedsLayout];//这个时候得更新布局了
    }
}

- (void)updateComponentOnMainThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events{
    [super updateComponentOnMainThreadWithAttributes:attributes styles:styles events:events];
    if(_label.attributedText != _textAttributedString){
        
        //在屏幕中的同步渲染 在屏幕外的异步渲染
        [self _updateLableAsyncRender];
        _label.drawAtPoint = CGPointMake(0, _lineHeightOffset);
        _label.attributedText = _textAttributedString;
    }
}



- (CGSize (^)(CGSize))calculateComponentSizeBlock{
    kBlockWeakSelf;
    return ^CGSize (CGSize constrainedSize) {
        if(weakSelf){
            return [weakSelf _calculateComponentWithSize:constrainedSize];
        }else {
            return CGSizeZero;
        }
    };
}

- (void)mainQueueWillSyncBeforeAnimation{
    BOOL isLoad = [self isViewLoaded];
    [super mainQueueWillSyncBeforeAnimation ];
    if(!isLoad){
        CGSize size = self.view.bounds.size;
        _label.frame = CGRectMake(self.contentEdge.left, self.contentEdge.top,size.width - self.contentEdge.left - self.contentEdge.right,0);
    }
}

#pragma mark - private

//填充styles
- (BOOL)_fillTextComponentStyles:(NSDictionary *)styles isInit:(BOOL)isInit{
    if(![styles isKindOfClass:[NSDictionary class]] || styles.count == 0) return false;
    id value = nil;
    BOOL needUpdate = NO;
    
    CGFloat fontWeightDefaultValue = 0;
    if(@available(iOS 8.2, *)){
        fontWeightDefaultValue = UIFontWeightRegular;
    }
    VA_FILL_TEXT_STYLE(color, _color, convertToColor,[UIColor blackColor]);
    VA_FILL_TEXT_STYLE(fontSize, _fontSize, convertToFloatWithPixel,15);
    VA_FILL_TEXT_STYLE(fontWeight, _fontWeight, converToTextWeight,fontWeightDefaultValue);
    VA_FILL_TEXT_STYLE(fontFamily, _fontFamily, convertToString,nil);
    VA_FILL_TEXT_STYLE(fontStyle, _fontStyle, convertToTextStyle,VATextStyleNormal);
    VA_FILL_TEXT_STYLE(lines, _maxLines, convertToInteger,0);
    VA_FILL_TEXT_STYLE(textAlign, _textAlign, convertToTextAlignment,NSTextAlignmentLeft);
    VA_FILL_TEXT_STYLE(textDecoration, _textDecoration, convertToTextDecoration,VATextDecorationNone);
    VA_FILL_TEXT_STYLE(textOverflow, _lineBreakMode, convertToTextOverflow,NSLineBreakByTruncatingTail);
    VA_FILL_TEXT_STYLE(lineHeight, _lineHeight, convertToFloatWithPixel,0);
    VA_FILL_TEXT_STYLE(letterSpacing, _letterSpacing, convertToFloatWithPixel,0);
    VA_FILL_TEXT_STYLE(lineSpacing, _lineSpacing, convertToFloatWithPixel,5);
    
    return needUpdate;
}

//填充属性
- (BOOL)_fillTextComponentAttr:(NSDictionary *)attrs{
    if(![attrs isKindOfClass:[NSDictionary class]] || attrs.count == 0) return false;
    BOOL needUpdate = NO;
    NSString * value = attrs[@"value"];
    if(value){
        NSString * text = [VAConvertUtl convertToString:value];
        _text = text;
        needUpdate = true;
        
    }
    return needUpdate;
}




//创建富文本
- (nullable  NSMutableAttributedString *)_buildNewAttributedString{
    //逻辑几乎都在这里    //头大
    
    if(_text.length <= 0) return nil;
    
    
    NSRange range = NSMakeRange(0, _text.length);

    UIFont * font = [self _getFontWithSize:_fontSize weight:_fontWeight fontFamily:_fontFamily fontStyle:_fontStyle];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:_text attributes:@{NSFontAttributeName:font?:[NSNull null],NSForegroundColorAttributeName:_color?:[UIColor blackColor]}];

    
    if(_letterSpacing){
        [attributedString addAttribute:NSKernAttributeName value:@(_letterSpacing) range:range];
    }
    
    if(_textDecoration == VATextDecorationUnderline){
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
    } else if(_textDecoration == VATextDecorationLineThrough){
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
    }
    
    
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.alignment = _textAlign;// type NSTextAlignment
    
    _lineHeightOffset = 0;
    if(_lineHeight){
        style.minimumLineHeight = _lineHeight;
        style.maximumLineHeight = _lineHeight;
        if(_lineHeight > _fontSize){
            _lineHeightOffset = -(_lineHeight - _fontSize) / 2;//fix
        }

    }
    style.lineSpacing = _lineSpacing;


    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedString.string.length)];
    return attributedString;

}
//计算内容大小
- (CGSize)_calculateComponentWithSize:(CGSize)constrainedSize{
    kBlockWeakSelf;
    if (isnan(constrainedSize.width) && isnan(constrainedSize.height)) { //scroller && 横向布局 就不必做特殊处理 todo tomqiu
        CGFloat maxWidth = self.violaInstance.rootView.frame.size.width;
        VAComponent * supercomponent = weakSelf.supercomponent;
        NSMutableArray * parents = [NSMutableArray arrayWithObject:self];
        VAComponent * rootComponent = self.violaInstance.componentController.rootComponent;
        while (supercomponent) {
            [parents addObject:supercomponent];
            if(supercomponent == rootComponent){
                break;
            }
            supercomponent = supercomponent.supercomponent;
        }
        CGFloat edgeWidth = 0;
        for(int i = (int)parents.count - 1 ; i >= 0 ; i--){
            VAComponent * compoent = parents[i];
            edgeWidth += (compoent.contentEdge.left + compoent.contentEdge.right);
            if(i - 1 >= 0){
                VAComponent * nextCompoent = parents[i - 1];
                edgeWidth += (nextCompoent->_cssNode->style.margin[CSS_LEFT] + nextCompoent->_cssNode->style.margin[CSS_RIGHT] );
            }
        }
        constrainedSize.width = maxWidth - edgeWidth;
    }
    
    CGFloat width = isnan(constrainedSize.width) ? CGFLOAT_MAX  : constrainedSize.width;
    CGFloat height = isnan(constrainedSize.height) ? CGFLOAT_MAX  : constrainedSize.height;
    
    if (!isnan(_cssNode->style.minDimensions[CSS_WIDTH])) {
        width = MAX(width, _cssNode->style.minDimensions[CSS_WIDTH]);
    }
    
    if (!isnan(_cssNode->style.maxDimensions[CSS_WIDTH])) {
        width = MIN(width, _cssNode->style.maxDimensions[CSS_WIDTH]);
    }
    
    if (!isnan(_cssNode->style.minDimensions[CSS_HEIGHT])) {
        height = MAX(height, _cssNode->style.minDimensions[CSS_HEIGHT]);
    }
    
    if (!isnan(_cssNode->style.maxDimensions[CSS_HEIGHT])) {
        height = MIN(height, _cssNode->style.maxDimensions[CSS_HEIGHT]);
    }
    

    CGSize res = CGSizeZero;
    
    if(_textAttributedString.string.length == 0){
        res = CGSizeZero;
    }else {
       res = [RIJAsyncLabel sizeThatFits:CGSizeMake(width, height) attributedString:_textAttributedString numberOfLines:_maxLines lineBreakMode:_lineBreakMode];
    }
    
    if (!isnan(_cssNode->style.minDimensions[CSS_WIDTH])) {
        res.width = MAX(res.width, _cssNode->style.minDimensions[CSS_WIDTH]);
    }
    
    if (!isnan(_cssNode->style.maxDimensions[CSS_WIDTH])) {
        res.width = MIN(res.width, _cssNode->style.maxDimensions[CSS_WIDTH]);
    }
    
    if (!isnan(_cssNode->style.minDimensions[CSS_HEIGHT])) {
        res.height = MAX(res.height, _cssNode->style.minDimensions[CSS_HEIGHT]);
    }
    
    if (!isnan(_cssNode->style.maxDimensions[CSS_HEIGHT])) {
        res.height = MIN(res.height, _cssNode->style.maxDimensions[CSS_HEIGHT]);
    }
    return res;
}

//在屏幕中的同步渲染 在屏幕外的异步渲染
- (void) _updateLableAsyncRender{
    
    if(!CGRectEqualToRect(self.view.frame, self.componentFrame)){
        self.view.frame = self.componentFrame;
    }
    CGRect location = [self.view convertRect:self.view.bounds toView:nil];//在屏幕中的位置 //如果
    CGRect windowBound = self.view.window.bounds;
    if(CGRectIntersectsRect(location, windowBound) || CGRectContainsRect(location, windowBound)){
        _label.displaysAsynchronously = false;
    }else {
        _label.displaysAsynchronously = true;
    }
}

//fontFamily 待支持 todo tomqiu
- (UIFont *) _getFontWithSize:(CGFloat)size weight:(CGFloat)weight fontFamily:(NSString *)family fontStyle:(VATextStyle)textStyle{
    if (@available(iOS 8.2, *)) {
       return  [UIFont systemFontOfSize:size weight:weight];
    } else {
        if(_fontWeight){
            return [UIFont boldSystemFontOfSize:size];
        }
        return [UIFont systemFontOfSize:size];
    }
}

@end
