//
//  RIJAsyncLabel.h
//  QLXKitDemo
//
//  Created by 邱良雄 on 2018/4/5.
//  Copyright © 2018年 QLX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
NS_ASSUME_NONNULL_BEGIN


extern NSString *const RIJHighlightAttributeKey;



@interface RIJAsyncLabel : UIView
/**
 是否异步渲染 default YES
 */
@property (nonatomic, assign) BOOL displaysAsynchronously;
/**
 富文本属性
 */
@property (nonatomic, strong, nullable) NSAttributedString * attributedText;

@property (nonatomic, assign) NSLineBreakMode lineBreakMode;//default is NSLineBreakByTruncatingTail
@property (nonatomic, assign) NSInteger numberOfLines;

/**
 * 获取富文本的对应尺寸大小
 * note：任意线程都可以调用该方法，一般用于 子线程 执行
 */
+ (CGSize)sizeThatFits:(CGSize)size attributedString:(NSAttributedString *)attString numberOfLines:(NSUInteger)lines lineBreakMode:(NSLineBreakMode)mode;
+ (CGSize)sizeThatFits:(CGSize)size attributedString:(NSAttributedString *)attString numberOfLines:(NSUInteger)lines lineBreakMode:(NSLineBreakMode)mode lineBreakMarin:(CGFloat)marin;

/**
 自动布局中的自动换行最大宽度
 */
@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

/**
 TextKit 中的一个 类NSAttributedString 富文本
 */
@property (nonatomic, strong, nullable) NSTextStorage * textStorage;

@property (nonatomic, assign) UIEdgeInsets touchFrameAddEdge;

@property (nonatomic, assign) CGPoint drawAtPoint;



@end




//------RIJHighlightAttribute类分割线-----

@interface RIJHighlightAttribute : NSObject

@property (nonatomic, strong) UIColor * highlightBackgroudColor;//高亮背景色
@property (nonatomic, assign) UIEdgeInsets highlightBackgroudInset;//相对于字符区域的边距
@property (nonatomic, assign) CGFloat highlightBackgroudRadius;//高亮背景矩形的圆角



@end
//------RIJLayoutManager类分割线-----

@interface RIJLayoutManager : NSLayoutManager

@property (nonatomic, assign) NSRange highlightRange;
@property (nullable, nonatomic, strong) RIJHighlightAttribute * highlightAttribute;

@end




//---------RIJTextRender类分割线------------
@interface RIJTextRender : NSObject

@property (nonatomic, strong, nullable) NSTextStorage *textStorage;
@property (nonatomic, strong, readonly) RIJLayoutManager * layoutManager;
@property (nonatomic, strong, readonly) NSTextContainer *textContainer;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat lineFragmentPadding;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, assign) NSUInteger maximumNumberOfLines;
@property (nonatomic, assign, readonly) CGRect textBound;
@property (nonatomic, assign) BOOL isBreakLine;//是否被截断

@property (nonatomic, assign) CGFloat lineBreakMargin;//截断边距
// initialize
- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText;
- (instancetype)initWithTextStorage:(NSTextStorage *)textStorage;

@property (nonatomic, strong, readonly, nullable) NSArray<NSTextAttachment *> *attachmentViews;
@property (nonatomic, strong, readonly, nullable) NSSet<NSTextAttachment *> *attachmentViewSet;

- (NSRange)visibleGlyphRange ;
- (NSRange)visibleCharacterRange ;
- (CGRect)boundingRectForCharacterRange:(NSRange)characterRange;
- (CGRect)boundingRectForGlyphRange:(NSRange)glyphRange ;
- (CGSize)textSizeWithRenderWidth:(CGFloat)renderWidth;
- (NSInteger)characterIndexForPoint:(CGPoint)point;

/**
 draw text at point
 */
- (void)drawTextAtPoint:(CGPoint)point isCanceled:(BOOL (^__nullable)(void))isCanceled;

@end



//------RIJTextAsyncLayer类分割线-----

@class RIJTextAsyncLayerDisplayTask;

@interface RIJTextAsyncLayer : CALayer
///Default is YES
@property BOOL displaysAsynchronously;
@end


@protocol RIJTextAsyncLayerDelegate <NSObject>
@required

- (RIJTextAsyncLayerDisplayTask *)newAsyncDisplayTask;
@end


@interface RIJTextAsyncLayerDisplayTask : NSObject


@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);


@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL(^isCancelled)(void));


@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);

@end


// ------- 类分割线--------

@interface NSAttributedString(MIJAsync)
@property(nullable, nonatomic, strong) RIJTextRender * rij_textRender;
@property(nonatomic, assign) CGSize rij_size;
@end


NS_ASSUME_NONNULL_END

