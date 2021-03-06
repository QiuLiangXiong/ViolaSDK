//
//  RIJAsyncLabel.m
//  QQMainProject
//
//  Created by 邱良雄 on 2018/4/5.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "RIJAsyncLabel.h"
#import <pthread.h>
#import <libkern/OSAtomic.h>
#import "objc/runtime.h"
#define RIJAssertMainThread() NSAssert(0 != pthread_main_np(), @"This method must be called on the main thread!")
NSString *const RIJHighlightAttributeKey = @"RIJHighlightAttributeKey";
@interface RIJAsyncLabel()<RIJTextAsyncLayerDelegate>

@property (nullable, nonatomic, strong) NSTextStorage * textStorageOnRender;
@property (nullable, nonatomic, strong) RIJTextRender * textRenderOnDisplay;
@property (nullable, nonatomic, strong) RIJTextRender * textRender;

@end

@implementation RIJAsyncLabel
@synthesize displaysAsynchronously = _displaysAsynchronously;


+ (Class)layerClass{
    return [RIJTextAsyncLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureLabel];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureLabel];
    }
    return self;
}

#pragma mark - 配置

- (void)configureLabel{
    _displaysAsynchronously = true;
    _numberOfLines = 0;
    _lineBreakMode = NSLineBreakByTruncatingTail;
    self.opaque = false;
    self.backgroundColor = [UIColor clearColor];
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.delegate = self;
}



#pragma mark - Display

- (void)setDisplayNeedUpdate{
    RIJAssertMainThread();
    [self clearTextRender];
    [self clearLayerContent];
    [self setDisplayNeedRedraw];
}

- (void)setDisplayNeedRedraw{
    [self.layer setNeedsDisplay];
}

- (void)displayRedrawIfNeed{
    [self clearLayerContent];
    [self setDisplayNeedRedraw];
}

- (void)immediatelyDisplayRedraw {
    [self.layer setNeedsDisplay];
    [self.layer displayIfNeeded];
}

- (void)clearLayerContent {
    if (self.displaysAsynchronously) {
        self.layer.contents = nil;
    }
}
- (void)clearTextRender{
    _textRender = nil;
}
//内容改变 需要做的事情
- (void)contentChanged{
    [self setDisplayNeedUpdate];
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Getter && Setter

- (BOOL)displaysAsynchronously{
    return ((RIJTextAsyncLayer *)self.layer).displaysAsynchronously;
}

- (void)setDisplaysAsynchronously:(BOOL)displaysAsynchronously{
    ((RIJTextAsyncLayer *)self.layer).displaysAsynchronously = displaysAsynchronously;
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    _attributedText = attributedText;
    if (attributedText.rij_textRender) {
        self.textRender = attributedText.rij_textRender;
        self.numberOfLines = self.textRender.textContainer.maximumNumberOfLines;//fix
        self.lineBreakMode = self.textRender.textContainer.lineBreakMode;//fix
    }else {
        _textStorageOnRender = [[NSTextStorage alloc] initWithAttributedString:attributedText];
        [self contentChanged];
    }
    
}


- (void)setTextStorage:(NSTextStorage *)textStorage{
    _textStorage = textStorage;
    _attributedText = nil;
    _textStorageOnRender = textStorage;
    [self contentChanged];
}

- (void)setTextRender:(RIJTextRender *)textRender{
    _textRender = textRender;
    _textStorageOnRender = textRender.textStorage;
    [self clearLayerContent];
    [self setDisplayNeedRedraw];
    [self invalidateIntrinsicContentSize];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    _lineBreakMode = lineBreakMode;
    [self displayRedrawIfNeed];
    [self invalidateIntrinsicContentSize];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    _numberOfLines = numberOfLines;
    [self displayRedrawIfNeed];
    [self invalidateIntrinsicContentSize];
}

- (void)setFrame:(CGRect)frame{
    RIJAssertMainThread();
    CGSize oldSize = self.frame.size;
    [super setFrame:frame];
    if (!CGSizeEqualToSize(self.frame.size, oldSize)) {
        [self clearLayerContent];
        [self setDisplayNeedRedraw];
    }
}

- (void)setBounds:(CGRect)bounds{
    RIJAssertMainThread();
    CGSize oldSize = self.bounds.size;
    [super setBounds:bounds];
    if (!CGSizeEqualToSize(self.bounds.size, oldSize)) {
        [self clearLayerContent];
        [self setDisplayNeedRedraw];
    }
}

#pragma mark - Layout Size

- (CGSize)sizeThatFits:(CGSize)size{
    return [self contentSizeWithWidth:size.width];
}

- (CGSize)intrinsicContentSize{
    CGFloat width = _preferredMaxLayoutWidth > 0 ? _preferredMaxLayoutWidth : CGRectGetWidth(self.frame);
    return [self contentSizeWithWidth:width>0?width:10000];
}

- (CGSize)contentSizeWithWidth:(CGFloat)width{
    if (_textRender) {
        if (fabs(_textRender.size.width - width)<0.1 || _textRender.size.height == 0 || _textRender.size.width == 0) {
            return [_textRender textSizeWithRenderWidth:width];
        }
        return _textRender.size;
    }
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[_textStorageOnRender mutableCopy]];
    RIJTextRender *textRender = [[RIJTextRender alloc] initWithTextStorage:textStorage];
    textRender.maximumNumberOfLines = _numberOfLines;
    textRender.lineBreakMode = _lineBreakMode;
    return [textRender textSizeWithRenderWidth:width];
}

#pragma mark - public

+ (CGSize)sizeThatFits:(CGSize)size attributedString:(NSAttributedString *)attString numberOfLines:(NSUInteger)lines lineBreakMode:(NSLineBreakMode)mode{
    return [self sizeThatFits:size attributedString:attString numberOfLines:lines lineBreakMode:mode lineBreakMarin:0];
}

+ (CGSize)sizeThatFits:(CGSize)size attributedString:(NSAttributedString *)attString numberOfLines:(NSUInteger)lines lineBreakMode:(NSLineBreakMode)mode lineBreakMarin:(CGFloat)marin{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attString];
    RIJTextRender *textRender = [[RIJTextRender alloc] initWithTextStorage:textStorage];
    textRender.lineBreakMargin = marin;
    textRender.maximumNumberOfLines = lines;
    textRender.lineBreakMode = mode;
    CGSize fitSize = [textRender textSizeWithRenderWidth:size.width];
    if (marin > 0 && lines) {
        textRender.maximumNumberOfLines = 0;
        CGSize newSize = [textRender textSizeWithRenderWidth:size.width];
        textRender.isBreakLine = !CGSizeEqualToSize(fitSize, newSize);
        textRender.maximumNumberOfLines = lines;//复原
    }
    attString.rij_textRender = textRender;
    attString.rij_size = fitSize;
    return fitSize;
}

#pragma mark - sync delegate

- (RIJTextAsyncLayerDisplayTask *)newAsyncDisplayTask{
    __block RIJTextRender * textRender = _textRender;
    __block NSTextStorage * textStorage = _textStorageOnRender;
    
    NSInteger numberOfLines = _numberOfLines;
    NSLineBreakMode lineBreakMode = _lineBreakMode;
    CGFloat lineBreakMargin = _textRender.lineBreakMargin;
    BOOL isLineBreak = _textRender.isBreakLine;
    RIJTextAsyncLayerDisplayTask * task = [RIJTextAsyncLayerDisplayTask new];
    
    CGSize attributedTextSize  = _attributedText.rij_size;
    task.willDisplay = ^(CALayer * _Nonnull layer) {
        _textRenderOnDisplay = nil;
    };
    task.display = ^(CGContextRef  _Nonnull context, CGSize size, BOOL (^ _Nonnull isCancelled)(void)) {
        if (!textRender) {
            textRender = [[RIJTextRender alloc] initWithTextStorage:textStorage];
            if (isCancelled()) return;
        }
        if (!textStorage) {
            return;
        }
        textRender.maximumNumberOfLines = numberOfLines;
        textRender.lineBreakMode = lineBreakMode;
        
        
        if (CGSizeEqualToSize(attributedTextSize, size) && numberOfLines ) {
            size = CGSizeMake(size.width, size.height + 50);//fix

            if(lineBreakMargin > 0 && isLineBreak){
                
                UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(size.width - lineBreakMargin, size.height - 60, lineBreakMargin, 10)];
                textRender.textContainer.exclusionPaths = @[bezierPath];
            }
        }
        textRender.size = size;
        
        
        
        if (isCancelled()) return ;
        [textRender drawTextAtPoint:self.drawAtPoint isCanceled:isCancelled];
        
    };
    task.didDisplay = ^(CALayer * _Nonnull layer, BOOL finished) {
        _textRenderOnDisplay = textRender;
    };
    return task;
}

- (void)dealloc {
    _textRender = nil;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!UIEdgeInsetsEqualToEdgeInsets(self.touchFrameAddEdge, UIEdgeInsetsZero) ) {
        UIEdgeInsets edge = self.touchFrameAddEdge;
        CGRect newBound = CGRectMake(self.bounds.origin.x -edge.left, self.bounds.origin.y - edge.top, self.bounds.size.width + edge.left + edge.right, self.bounds.size.height + edge.top + edge.bottom);
        result = CGRectContainsPoint(newBound, point);
    }
    return result;
}


#pragma mark - touch override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if(_textRenderOnDisplay){
        RIJLayoutManager * layoutManager = _textRenderOnDisplay.layoutManager;
        UITouch *touch = touches.anyObject;
        CGPoint point = [touch locationInView:self];
        NSRange range = NSMakeRange(0, 0);
        
        RIJHighlightAttribute * highlightAttribute = [self _getHighlightAttrWithPoint:point effectiveRange:&range];
        
        if (highlightAttribute.highlightBackgroudColor && range.length) {
            layoutManager.highlightRange = range;
            layoutManager.highlightAttribute = highlightAttribute;
            //临时设一下背景来触发背景
            [layoutManager.textStorage addAttribute:NSBackgroundColorAttributeName value:highlightAttribute.highlightBackgroudColor range:range];
            [self immediatelyDisplayRedraw];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        [self _endOrCancelTouch];
    }
    
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self _endOrCancelTouch];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self _endOrCancelTouch];
    [super touchesCancelled:touches withEvent:event];
}



#pragma mark - private

- (RIJHighlightAttribute *)_getHighlightAttrWithPoint:(CGPoint)point effectiveRange:(NSRangePointer)range {
    NSInteger index = [_textRenderOnDisplay characterIndexForPoint:point];
    if (index < 0) {
        return nil;
    }
    return [_textRender.textStorage attribute:RIJHighlightAttributeKey atIndex:index effectiveRange:range];
}

- (void)_endOrCancelTouch{
    if (_textRenderOnDisplay) {
        RIJLayoutManager * layoutManager = _textRenderOnDisplay.layoutManager;
        if (layoutManager.highlightAttribute) {
            [_textRenderOnDisplay.textStorage removeAttribute:NSBackgroundColorAttributeName range:layoutManager.highlightRange];
            layoutManager.highlightRange = NSMakeRange(0, 0);
            layoutManager.highlightAttribute = nil;
            [self immediatelyDisplayRedraw];
        }
        
    }
}

@end
//---------RIJTextRender类分割线------------
@interface RIJTextRender(){
    CGRect _textBound;
}
@property (nonatomic, strong) RIJLayoutManager * layoutManager;
@property (nonatomic, strong) NSTextContainer * textContainer;
@property (nonatomic, strong) NSTextStorage * textStorageOnRender;


@end
@implementation RIJTextRender
@synthesize maximumNumberOfLines = _maximumNumberOfLines;

- (instancetype)init{
    if (self = [super init]) {
        _textContainer = [NSTextContainer new];
        _layoutManager = [RIJLayoutManager new];
        [_layoutManager addTextContainer:_textContainer];
        _textContainer.lineFragmentPadding = 0;
    }
    return self;
}

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText{
    if (self = [self initWithTextStorage:[[NSTextStorage alloc] initWithAttributedString:attributedText]]) {
    }
    return self;
}

- (instancetype)initWithTextStorage:(NSTextStorage *)textStorage{
    if (self = [self init]) {
        self.textStorage = textStorage;
    }
    return self;
}
#pragma mark - Getter && Setter

- (void)setTextStorage:(NSTextStorage *)textStorage{
    _textStorage = textStorage;
    self.textStorageOnRender = textStorage;
}

- (void)setTextStorageOnRender:(NSTextStorage *)textStorageOnRender{
    if (_textStorageOnRender != textStorageOnRender) {
        if (_textStorageOnRender) {
            [_textStorageOnRender removeLayoutManager:_layoutManager];
        }
        [textStorageOnRender addLayoutManager:_layoutManager];
        _textStorageOnRender = textStorageOnRender;
    }
}

- (void)setSize:(CGSize)size{
    _size = size;
    if (!CGSizeEqualToSize(_textContainer.size, size)) {
        _textContainer.size = size;
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    if (_textContainer.lineBreakMode != lineBreakMode) {
        _textContainer.lineBreakMode = lineBreakMode;
    }
}

- (NSUInteger)maximumNumberOfLines{
    return _textContainer.maximumNumberOfLines;
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines{
    if (_textContainer.maximumNumberOfLines != maximumNumberOfLines) {
        _textContainer.maximumNumberOfLines = maximumNumberOfLines;
    }
}

#pragma mark - Public

- (NSRange)visibleGlyphRange {
    return [_layoutManager glyphRangeForTextContainer:_textContainer];
}

- (NSRange)visibleCharacterRange {
    return [_layoutManager characterRangeForGlyphRange:[self visibleGlyphRange] actualGlyphRange:nil];
}

- (CGRect)boundingRectForCharacterRange:(NSRange)characterRange {
    NSRange glyphRange = [_layoutManager glyphRangeForCharacterRange:characterRange actualCharacterRange:nil];
    return [self boundingRectForGlyphRange:glyphRange];
}

- (CGRect)boundingRectForGlyphRange:(NSRange)glyphRange {
    return [_layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:_textContainer];
}

- (CGRect)textBound {
    return [self boundingRectForGlyphRange:[self visibleGlyphRange]];
}

- (NSInteger)characterIndexForPoint:(CGPoint)point{
    CGFloat distanceToPoint = 1.0;
    NSUInteger index = [_layoutManager characterIndexForPoint:point inTextContainer:_textContainer fractionOfDistanceBetweenInsertionPoints:&distanceToPoint];
    return distanceToPoint < 1 ? index : -1;
}


- (CGSize)textSizeWithRenderWidth:(CGFloat)renderWidth{
    if (!_textStorageOnRender)  return CGSizeZero;
    CGSize size = _textContainer.size;
    _textContainer.size = CGSizeMake(renderWidth, MAXFLOAT);
    CGSize textSize = [self boundingRectForGlyphRange:[self visibleGlyphRange]].size;
    _textContainer.size = size;
    CGSize res = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    return  res;
    
    
    
}
#pragma mark -  draw text

//- (CGRect)textRectForGlyphRange:(NSRange)glyphRange atPiont:(CGPoint)point{
//    if (glyphRange.length == 0)  return CGRectZero;
//    CGPoint textOffset = point;
//    CGRect textBound = _textBound;
//    textBound = [self boundingRectForGlyphRange:glyphRange];
//    CGSize textSize = CGSizeMake(ceil(textBound.size.width), ceil(textBound.size.height));
//    textOffset.y = point.y;
//    textBound.origin = textOffset;
//    textBound.size = textSize;
//    return textBound;
//}

- (void)drawTextAtPoint:(CGPoint)point isCanceled:(BOOL (^)(void))isCanceled{
    NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
    // drawing text
    [_layoutManager enumerateLineFragmentsForGlyphRange:glyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
        [_layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:point];
        if (isCanceled && isCanceled()) {*stop = YES; return ;};
        [_layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:point];
        if (isCanceled && isCanceled()) {*stop = YES; return ;};
    }];
}

@end

//------RIJLayoutManager类分割线-----

@implementation RIJLayoutManager{
    CGPoint _drawAtPoint;
}

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin {
    _drawAtPoint = origin;
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
    _drawAtPoint = CGPointZero;
}

- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color {
    if (_highlightAttribute == nil || _highlightRange.length == 0 || NSIntersectionRange(_highlightRange, charRange).length > charRange.length) {
        [super fillBackgroundRectArray:rectArray count:rectCount forCharacterRange:charRange color:color];
        return;
    }
    for (int i = 0; i < rectCount; ++i) {
        CGRect rect = [self _caculateHighlightRect:rectArray[i] characterRange:charRange];
        [self _drawHighlightBackgroundRect:rect color:color];
    }
}



- (void)_drawHighlightBackgroundRect:(CGRect)rect color:(UIColor *)color{
    CGFloat radius = _highlightAttribute.highlightBackgroudRadius;
    UIEdgeInsets inset = _highlightAttribute.highlightBackgroudInset;
    
    
    CGFloat x = floor(rect.origin.x)- inset.left;
    CGFloat y  = ceil(rect.origin.y)- inset.top;
    CGFloat width = ceil(rect.size.width)+inset.left+inset.right;
    CGFloat height = ceil(rect.size.height)+inset.top+inset.bottom;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, x + radius, y);
    CGContextAddLineToPoint(context, x + width - radius, y);
    CGContextAddArc(context,x+ width - radius,y+ radius, radius, -0.5 * M_PI, 0.0, 0);
    CGContextAddLineToPoint(context, x + width,y + height - radius);
    CGContextAddArc(context,x+ width - radius,y+ height - radius, radius, 0.0, 0.5 * M_PI, 0);
    CGContextAddLineToPoint(context, x+radius, y+height);
    CGContextAddArc(context, x+radius,y+ height - radius, radius, 0.5 * M_PI, M_PI, 0);

    CGContextAddLineToPoint(context, x,y+ radius);
    CGContextAddArc(context,x+ radius,y+ radius, radius, M_PI, 1.5 * M_PI, 0);

    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextDrawPath(context, kCGPathFill);
}
- (CGRect)_caculateHighlightRect:(CGRect)rect characterRange:(NSRange)charRange {
    NSUInteger index = [self glyphIndexForCharacterAtIndex:charRange.location];
    CGRect lineBounds = [self lineFragmentUsedRectForGlyphAtIndex:index effectiveRange:NULL];
    lineBounds.origin.x += _drawAtPoint.x;
    lineBounds.origin.y += _drawAtPoint.y;
    CGFloat startDrawY = CGFLOAT_MAX;
    CGFloat maxLineHeight = 0.0f;
    for (NSInteger charIndex = charRange.location; charIndex<NSMaxRange(charRange); ++charIndex) {
        UIFont *font = [self.textStorage attribute:NSFontAttributeName
                                           atIndex:charIndex
                                    effectiveRange:nil];
        if (!font) {
            font = [UIFont systemFontOfSize:12];
        }
        NSUInteger glyphIndex = [self glyphIndexForCharacterAtIndex:charIndex];
        CGPoint location = [self locationForGlyphAtIndex:glyphIndex];
        CGFloat height = [self attachmentSizeForGlyphAtIndex:glyphIndex].height;
        startDrawY = fmin(startDrawY, lineBounds.origin.y+location.y-(height > 0 ?height :font.ascender));
        maxLineHeight = fmax(maxLineHeight, height > 0? height:font.lineHeight);
    }
    lineBounds.origin.y = startDrawY;
    lineBounds.size.height = maxLineHeight;
    return CGRectIntersection(lineBounds, rect);
}

@end


//-------RIJHighlightAttribute分割线----------
@implementation RIJHighlightAttribute
@end

//-----------RIJTextAsyncLayer类分割线-----------
static dispatch_queue_t RIJTextAsyncLayerGetDisplayQueue() {
#define MAX_QUEUE_COUNT 10  //orgin 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            for (NSUInteger i = 0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.tencent.text.render", attr);
            }
        } else {
            for (NSUInteger i = 0; i < queueCount; i++) {
                queues[i] = dispatch_queue_create("com.ibireme.text.render", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    uint32_t cur = (uint32_t)OSAtomicIncrement32(&counter);
    return queues[(cur) % queueCount];
#undef MAX_QUEUE_COUNT
}
static dispatch_queue_t RIJTextAsyncLayerGetReleaseQueue() {
#ifdef YYDispatchQueuePool_h
    return YYDispatchQueueGetForQOS(NSQualityOfServiceDefault);
#else
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
#endif
}
/// a thread safe incrementing counter.
@interface _RIJTextSentinel : NSObject
@property (atomic, readonly) int32_t value;
- (int32_t)increase;
@end
@implementation _RIJTextSentinel {
    int32_t _value;
}
- (int32_t)value {
    return _value;
}
- (int32_t)increase {
    return OSAtomicIncrement32(&_value);
}
@end
@implementation RIJTextAsyncLayerDisplayTask
@end

@implementation RIJTextAsyncLayer {
    _RIJTextSentinel *_sentinel;
}
#pragma mark - Override
+ (id)defaultValueForKey:(NSString *)key {
    if ([key isEqualToString:@"displaysAsynchronously"]) {
        return @(YES);
    } else {
        return [super defaultValueForKey:key];
    }
}
- (instancetype)init {
    self = [super init];
    static CGFloat scale; //global
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    self.contentsScale = scale;
    _sentinel = [_RIJTextSentinel new];
    _displaysAsynchronously = YES;
    return self;
}
- (void)dealloc {
    [_sentinel increase];
}
- (void)setNeedsDisplay {
    [self _cancelAsyncDisplay];
    [super setNeedsDisplay];
}
- (void)display {
    super.contents = super.contents;
    [self _displayAsync:_displaysAsynchronously];
}
#pragma mark - Private
- (void)_displayAsync:(BOOL)async {
    __strong id<RIJTextAsyncLayerDelegate> delegate = (id)self.delegate;
    RIJTextAsyncLayerDisplayTask *task = [delegate newAsyncDisplayTask];
    if (!task.display) {
        if (task.willDisplay) task.willDisplay(self);
        self.contents = nil;
        if (task.didDisplay) task.didDisplay(self, YES);
        return;
    }
    
    if (async) {
        if (task.willDisplay) task.willDisplay(self);
        _RIJTextSentinel *sentinel = _sentinel;
        int32_t value = sentinel.value;
        BOOL (^isCancelled)(void) = ^BOOL() {
            return value != sentinel.value;
        };
        CGSize size = self.bounds.size;
        BOOL opaque = self.opaque;
        CGFloat scale = self.contentsScale;
        CGColorRef backgroundColor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;
        if (size.width < 1 || size.height < 1) {
            CGImageRef image = (__bridge_retained CGImageRef)(self.contents);
            self.contents = nil;
            if (image) {
                dispatch_async(RIJTextAsyncLayerGetReleaseQueue(), ^{
                    CFRelease(image);
                });
            }
            if (task.didDisplay) task.didDisplay(self, YES);
            CGColorRelease(backgroundColor);
            return;
        }
        
        dispatch_async(RIJTextAsyncLayerGetDisplayQueue(), ^{
            if (isCancelled()) {
                CGColorRelease(backgroundColor);
                return;
            }
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (opaque && context) {
                CGContextSaveGState(context); {
                    if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                        CGContextFillPath(context);
                    }
                    if (backgroundColor) {
                        CGContextSetFillColorWithColor(context, backgroundColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                        CGContextFillPath(context);
                    }
                } CGContextRestoreGState(context);
                CGColorRelease(backgroundColor);
            }
            task.display(context, size, isCancelled);
            if (isCancelled()) {
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) task.didDisplay(self, NO);
                });
                return;
            }
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (isCancelled()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) task.didDisplay(self, NO);
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCancelled()) {
                    if (task.didDisplay) task.didDisplay(self, NO);
                } else {
                    self.contents = (__bridge id)(image.CGImage);
                    if (task.didDisplay) task.didDisplay(self, YES);
                }
            });
        });
    } else {
        [_sentinel increase];
        if (task.willDisplay) task.willDisplay(self);
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.opaque && context) {
            CGSize size = self.bounds.size;
            size.width *= self.contentsScale;
            size.height *= self.contentsScale;
            CGContextSaveGState(context); {
                if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
                if (self.backgroundColor) {
                    CGContextSetFillColorWithColor(context, self.backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
            } CGContextRestoreGState(context);
        }
        task.display(context, self.bounds.size, ^{return NO;});
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.contents = (__bridge id)(image.CGImage);
        if (task.didDisplay) task.didDisplay(self, YES);
    }
}
- (void)_cancelAsyncDisplay {
    [_sentinel increase];
}
@end
@implementation NSAttributedString(MIJAsync)
@dynamic rij_textRender;
@dynamic rij_size;
-(RIJTextRender *)rij_textRender{
    return objc_getAssociatedObject(self, @selector(rij_textRender));
}
- (void)setRij_textRender:(RIJTextRender *)rij_textRender{
    objc_setAssociatedObject(self, @selector(rij_textRender), rij_textRender, OBJC_ASSOCIATION_RETAIN);
}
- (CGSize)rij_size{
    return [objc_getAssociatedObject(self, @selector(rij_size)) CGSizeValue];
}
- (void)setRij_size:(CGSize)rij_size{
    objc_setAssociatedObject(self, @selector(rij_size), [NSValue valueWithCGSize:rij_size], OBJC_ASSOCIATION_RETAIN);
}
@end

