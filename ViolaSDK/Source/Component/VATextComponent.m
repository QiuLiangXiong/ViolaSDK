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
#import "VABridgeManager.h"
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

    //attr
    NSString *_text;
    NSArray *_texts;//多片段文本 用来显示富文本
    
    
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
    
    CGFloat _headIndent;
    CGFloat _lineBreakMargin;
    
    UIColor * _highlightBackgroundColor;
    CGFloat _highlightBackgroundRadius;
    UIEdgeInsets _highlightBackgroundInset;
    

    RIJAsyncLabel * _label;
    NSMutableAttributedString * _textAttributedString;
    CGFloat _lineHeightOffset;//修正RIJAsyncLabel 行高首行问题
    
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

//单击回调
- (void)onSingleClickWithSender:(id)sender{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
         UITapGestureRecognizer * tagGR = (UITapGestureRecognizer *)sender;
        CGPoint location = [tagGR locationInView:_label];
        if (CGRectContainsPoint(_label.bounds, location)) {
            RIJTextRender * textRender = _textAttributedString.rij_textRender;
            NSInteger index = [textRender characterIndexForPoint:location];
            if(index >= 0){
                NSDictionary * textInfo = [self _getTextInfoWithCharIndex:index];
                if (textInfo) {
                    [self _fireEventWithName:@"click" extralParam:@{@"textInfo":textInfo}];
                    return;
                }
            }
        }
    }
    return [super onSingleClickWithSender:sender];

    
}

#pragma mark - private

//填充styles
- (BOOL)_fillTextComponentStyles:(NSDictionary *)styles isInit:(BOOL)isInit{
    if(![styles isKindOfClass:[NSDictionary class]]) return false;
    id value = nil;
    BOOL needUpdate = NO;
    
    CGFloat fontWeightDefaultValue = 0;
    if(@available(iOS 8.2, *)){
        fontWeightDefaultValue = UIFontWeightRegular;
    }
    VA_FILL_TEXT_STYLE(color, _color, convertToColor,[UIColor blackColor]);
    VA_FILL_TEXT_STYLE(fontSize, _fontSize, convertToFloatWithPixel,12);
    VA_FILL_TEXT_STYLE(fontWeight, _fontWeight, converToTextWeight,fontWeightDefaultValue);
    VA_FILL_TEXT_STYLE(fontFamily, _fontFamily, convertToString,nil);
    VA_FILL_TEXT_STYLE(fontStyle, _fontStyle, convertToTextStyle,VATextStyleNormal);
    VA_FILL_TEXT_STYLE(lines, _maxLines, convertToInteger,0);
    VA_FILL_TEXT_STYLE(textAlign, _textAlign, convertToTextAlignment,NSTextAlignmentLeft);
    VA_FILL_TEXT_STYLE(textDecoration, _textDecoration, convertToTextDecoration,VATextDecorationNone);
    VA_FILL_TEXT_STYLE(textOverflow, _lineBreakMode, convertToTextOverflow,NSLineBreakByTruncatingTail);
    VA_FILL_TEXT_STYLE(lineHeight, _lineHeight, convertToFloatWithPixel,0);
    VA_FILL_TEXT_STYLE(letterSpacing, _letterSpacing, convertToFloatWithPixel,0);
    VA_FILL_TEXT_STYLE(lineSpacing, _lineSpacing, convertToFloatWithPixel,MAXFLOAT);
    VA_FILL_TEXT_STYLE(headIndent, _headIndent, convertToFloatWithPixel,0);
    VA_FILL_TEXT_STYLE(lineBreakMargin,_lineBreakMargin, convertToFloatWithPixel,0);
    VA_FILL_TEXT_STYLE(highlightBackgroundRadius, _highlightBackgroundRadius, convertToFloatWithPixel,2);
    VA_FILL_TEXT_STYLE(highlightBackgroundColor, _highlightBackgroundColor, convertToColor,nil);
    VA_FILL_TEXT_STYLE(highlightBackgroudInset, _highlightBackgroundInset, converToEdgeInsets,UIEdgeInsetsZero);
    

    

    
    
    
    return needUpdate;
}

//填充属性
- (BOOL)_fillTextComponentAttr:(NSDictionary *)attrs{
    if(![attrs isKindOfClass:[NSDictionary class]] ) return false;
    BOOL needUpdate = NO;
    id value = attrs[@"value"];
    if(value){
        NSString * text = [VAConvertUtl convertToString:value];
        _text = text;
        needUpdate = true;
        
    }
    value = attrs[@"values"];
    if(value){
       _texts = [value isKindOfClass:[NSArray class]] ? value : nil;
       needUpdate = true;
    }
    return needUpdate;
}


#define VA_TEXT_STYLE_VALUE(key0,key1) \
(textInfo[@#key0] ? : textInfo[@#key1])

//创建富文本
- (nullable  NSMutableAttributedString *)_buildNewAttributedString{
    
    if(_text.length == 0 && _texts.count == 0) return nil;
    NSMutableAttributedString * res = nil;
    NSArray * texts = [_texts isKindOfClass:[NSArray class]] ? [_texts copy] : nil;
    if(texts.count){
        BOOL isFirstLineHeight = true;
        _lineHeightOffset = 0;
        res = [[NSMutableAttributedString alloc] init];
        for (NSDictionary * textInfo in texts) {
            if(![textInfo isKindOfClass:[NSDictionary class]]) continue;
            NSString * text = [VAConvertUtl convertToString:textInfo[@"text"]];
            if(text.length == 0) continue;
            CGFloat fontSize = [VAConvertUtl convertToFloatWithPixel:VA_TEXT_STYLE_VALUE(fontSize, font-size)] ? : _fontSize;
            CGFloat fontWeight = [VAConvertUtl converToTextWeight:VA_TEXT_STYLE_VALUE(textWeight, text-weight)] ? : _fontWeight;
            NSString * fontFamily = [VAConvertUtl convertToString:VA_TEXT_STYLE_VALUE(fontFamily, font-family)] ? : _fontFamily;
            VATextStyle fontStyle = [VAConvertUtl convertToTextStyle:VA_TEXT_STYLE_VALUE(fontStyle, font-style)] ? : _fontStyle;
            UIColor * color = [VAConvertUtl convertToColor:textInfo[@"color"]] ? : _color;
            CGFloat letterSpacing = [VAConvertUtl convertToFloatWithPixel:VA_TEXT_STYLE_VALUE(letterSpacing, letter-spacing)] ? : _letterSpacing;
            VATextDecoration textDecoration = [VAConvertUtl convertToTextDecoration:VA_TEXT_STYLE_VALUE(textDecoration, text-decoration)] ? : _textDecoration;
            NSTextAlignment textAlign = [VAConvertUtl convertToTextAlignment:VA_TEXT_STYLE_VALUE(textAlign, text-align)] ? : _textAlign;
            CGFloat lineHeight = [VAConvertUtl convertToFloatWithPixel:VA_TEXT_STYLE_VALUE(lineHeight, line-height)] ? : _lineHeight;
            CGFloat lineSpacing = [VAConvertUtl convertToFloatWithPixel:VA_TEXT_STYLE_VALUE(lineSpacing, line-spacing)] ? : _lineSpacing;
            CGFloat headIndent = [VAConvertUtl convertToFloatWithPixel:VA_TEXT_STYLE_VALUE(headIndent, head-indent)] ? : _headIndent;

            UIColor * hilightBGColor = [VAConvertUtl convertToColor:VA_TEXT_STYLE_VALUE(highlightBackgroundColor, highlight-background-color)] ? : _highlightBackgroundColor;
            CGFloat highlightBGRadius = [VAConvertUtl convertToFloatWithPixel:VA_TEXT_STYLE_VALUE(highlightBackgroundRadius, highlight-background-radius)] ? : _highlightBackgroundRadius;
            id value = VA_TEXT_STYLE_VALUE(highlightBackgroundInset, highlight-background-inset);
            UIEdgeInsets highlightBGInset = _highlightBackgroundInset;
            if (value) {
                highlightBGInset =  [VAConvertUtl converToEdgeInsets:value];
            }
            

            
            
            
            
            if(lineHeight && lineHeight > fontSize && isFirstLineHeight){
                isFirstLineHeight = false;
                 _lineHeightOffset = -(lineHeight - fontSize) / 2;
            }
            NSMutableAttributedString * textAtt = [self _getAttributedStringWith:text fontSize:fontSize fontWeight:fontWeight fontFamily:fontFamily fontStyle:fontStyle color:color letterSpacing:letterSpacing textDecoration:textDecoration textAlign:textAlign lineHeight:lineHeight lineSpacing:lineSpacing != MAXFLOAT ? lineSpacing : fontSize * 0.3 headIndent:headIndent  highlightBGColor:hilightBGColor highlightBGRadius:highlightBGRadius highlightBGInset:highlightBGInset];
            if(textAtt){
               [res appendAttributedString:textAtt];
            }

        }
    }else {
        res = [self _getAttributedStringWith:_text fontSize:_fontSize fontWeight:_fontWeight fontFamily:_fontFamily fontStyle:_fontStyle color:_color letterSpacing:_letterSpacing textDecoration:_textDecoration textAlign:_textAlign lineHeight:_lineHeight lineSpacing:_lineSpacing != MAXFLOAT ? _lineSpacing : _fontSize * 0.3 headIndent:_headIndent  highlightBGColor:_highlightBackgroundColor highlightBGRadius:_highlightBackgroundRadius highlightBGInset:_highlightBackgroundInset];
            _lineHeightOffset = 0;
            if(_lineHeight && _lineHeight > _fontSize){
                 _lineHeightOffset = -(_lineHeight - _fontSize) / 2;//fix
            }
    }
    return res;
}

- (nullable NSMutableAttributedString *)_getAttributedStringWith:(NSString *)text fontSize:(CGFloat)fontSize fontWeight:(CGFloat)fontWeight fontFamily:(NSString *)fontFamily fontStyle:(VATextStyle)fontStyle color:(UIColor *)color letterSpacing:(CGFloat)letterSpacing textDecoration:(VATextDecoration)textDecoration textAlign:(NSTextAlignment)textAliment lineHeight:(CGFloat)lineHeight lineSpacing:(CGFloat)lineSpacing headIndent:(CGFloat)headIndent highlightBGColor:(UIColor *)highightBGColor highlightBGRadius:(CGFloat)highlightBGRadius highlightBGInset:(UIEdgeInsets)highlightBGInset{
    if(text.length <= 0) return nil;
    
    NSRange range = NSMakeRange(0, text.length);
    
    UIFont * font = [self _getFontWithSize:fontSize weight:fontWeight fontFamily:fontFamily fontStyle:fontStyle];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font?:[NSNull null],NSForegroundColorAttributeName:color?:[UIColor blackColor]}];
    
    
    if(letterSpacing){
        [attributedString addAttribute:NSKernAttributeName value:@(letterSpacing) range:range];
    }
    
    if(textDecoration == VATextDecorationUnderline){
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    } else if(textDecoration == VATextDecorationLineThrough){
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    }
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.alignment = textAliment;
    if(_lineHeight){
        style.minimumLineHeight = _lineHeight;
        style.maximumLineHeight = _lineHeight;
    }
    style.lineSpacing = ceil(lineSpacing) ;
    style.firstLineHeadIndent = headIndent;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:range];
    if (highightBGColor) {
        RIJHighlightAttribute * highlightAtt = [RIJHighlightAttribute new];
        highlightAtt.highlightBackgroudColor = highightBGColor;
        highlightAtt.highlightBackgroudInset = highlightBGInset;
        highlightAtt.highlightBackgroudRadius = highlightBGRadius;
        [attributedString addAttribute:RIJHighlightAttributeKey value:highlightAtt range:range];
    }
    
  
    
    return attributedString;
}

//计算内容大小
- (CGSize)_calculateComponentWithSize:(CGSize)constrainedSize{
    kBlockWeakSelf;
    if (isnan(constrainedSize.width) && isnan(constrainedSize.height)) { //scroller && 横向布局 就不必做特殊处理 todo tomqiu
        CGFloat maxWidth = self.violaInstance.instanceFrame.size.width;
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
       res = [RIJAsyncLabel sizeThatFits:CGSizeMake(width, height) attributedString:_textAttributedString numberOfLines:_maxLines lineBreakMode:_lineBreakMode lineBreakMarin:_lineBreakMargin];
        if (_lineBreakMargin > 0) {
            //状态
            BOOL isLineBreak = _textAttributedString.rij_textRender.isBreakLine;
            [[VABridgeManager shareManager] fireEventWithIntanceID:_vaInstance.instanceId ref:_ref type:@"lineBreakChange" params:@{@"isLineBreak":@((int)isLineBreak)} domChanges:nil];
        }
        
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

- (NSDictionary *)_getTextInfoWithCharIndex:(NSUInteger)index{
    NSArray * texts = [_texts isKindOfClass:[NSArray class]] ? [_texts copy] : nil;
    if(texts.count){
        NSUInteger count = 0;
        for (NSDictionary * textInfo in texts) {
            if(![textInfo isKindOfClass:[NSDictionary class]]) continue;
            NSString * text = [VAConvertUtl convertToString:textInfo[@"text"]];
            if(text.length == 0) continue;
            count += text.length;
            if(index < count){
                return textInfo;
            }
        }
    }
    return nil;
}

@end
