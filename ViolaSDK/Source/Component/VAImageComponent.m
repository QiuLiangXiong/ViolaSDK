//
//  VAImageComponent.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/2.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAImageComponent.h"
#import "VAImageHandlerProtocol.h"
#import "VAConvertUtl.h"
#import "VADefine.h"
#import "VARegisterManager.h"

@interface VAImageComponent()

@property (nullable, nonatomic, strong)  id<VAImageOperationProtocol> imageOperation;
@property (nullable, nonatomic, strong)  id<VAImageOperationProtocol> placeHolderImageOperation;
@property (nullable, nonatomic, strong) NSString * placeholderUrl;
@property (nullable, nonatomic, strong) NSString * url;
@property (nullable, nonatomic, strong) UIImageView * imageView;

@end

@implementation VAImageComponent{

    UIViewContentMode  _contentMode;//图片占位模式
    CGFloat _aspectRatio;//图片宽高比
    CGFloat _blurRadius;//高斯模糊半径
    BOOL _fade;//淡入
    
}
#pragma mark - override
- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(ViolaInstance *)violaInstance{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:violaInstance]) {
        //
        [self _fillImageComponentStyles:styles isInit:true];
        [self _fillImageComponenAtts:attributes isInit:true];
        
        
        
//        BOOL showFade = ((options & YYWebImageOptionSetImageWithFadeAnimation) && !self.highlighted);
//        if (showFade) {
//            CATransition *transition = [CATransition animation];
//            transition.duration = stage == YYWebImageStageFinished ? _YYWebImageFadeTime : _YYWebImageProgressiveFadeTime;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionFade;
//            [self.layer addAnimation:transition forKey:_YYWebImageFadeAnimationKey];
//        }

    }
    return self;
}

- (UIView *)loadView{
    UIView * view = [[UIView alloc] init];;
    _imageView = [[UIImageView alloc] init];
    [view addSubview:_imageView];
    return view;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _imageView.clipsToBounds = true;
    _imageView.contentMode = _contentMode;

}

- (void)componentFrameDidChange{
    [super componentFrameDidChange];
    if (![self isViewLoaded]) {
        [self _syncImageToView];//等有了frame在加载
    }
}


- (void)componentFrameDidChangeOnMainQueue{
    [super componentFrameDidChangeOnMainQueue ];
    CGSize size = self.view.bounds.size;
    _imageView.frame = CGRectMake(self.contentEdge.left, self.contentEdge.top,size.width - self.contentEdge.left - self.contentEdge.right,size.height - self.contentEdge.top - self.contentEdge.bottom);
    
    //技术更新在迭代我们再加油
}

- (void)updateComponentOnComponentThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events{
    [super updateComponentOnComponentThreadWithAttributes:attributes styles:styles events:events];
    if ([self _fillImageComponentStyles:styles isInit:false]) {
        [self setNeedsLayout];
    }
    if ([self _fillImageComponenAtts:attributes isInit:false]) {
        [self _syncImageToView];//更新了属性再次更新加载图片
    }
}


- (void)updateComponentOnMainThreadWithAttributes:(NSDictionary *)attributes styles:(NSDictionary *)styles events:(NSArray *)events{
    [super updateComponentOnMainThreadWithAttributes:attributes styles:styles events:events];
    if (_imageView.contentMode != _contentMode) {
        _imageView.contentMode = _contentMode;//更新
    }
}

- (CGSize (^)(CGSize))calculateComponentSizeBlock{
    CGFloat aspectRatio = _aspectRatio;
    return ^CGSize (CGSize constrainedSize) {
        if(aspectRatio){
            if (!isnan(constrainedSize.width)) {
                constrainedSize.height = constrainedSize.width / aspectRatio;
            }else if(!isnan(constrainedSize.height)){
                constrainedSize.width = constrainedSize.height * aspectRatio;
            }
            return constrainedSize;
        }else {
            return CGSizeMake(NAN, NAN);//默认
        }
    };
}



#pragma mark - private

//填充属性
- (BOOL)_fillImageComponenAtts:(NSDictionary *)attrs isInit:(BOOL)isInit{
    BOOL needUpdate = NO;
    id value = attrs[@"src"] ? : (attrs[@"value"]?:attrs[@"url"]);//
    if (value) {
        _url = [[VAConvertUtl convertToString:value] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去除不可见字符
        needUpdate = true;
    }
    value = attrs[@"placeholder"] ? : attrs[@"placeHolder"];
    if (value) {
        _placeholderUrl = [[VAConvertUtl convertToString:value] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        needUpdate = true;
    }
    value = attrs[@"blurRadius"];
    if (value) {
        _blurRadius = [VAConvertUtl convertToFloatWithPixel:value];
        needUpdate = true;
    }
    value = attrs[@"resize"] ? : attrs[@"contentMode"];
    if (value) {
        _contentMode = [VAConvertUtl converToContentMode:value];
    }else if(isInit){
        _contentMode = UIViewContentModeScaleToFill;
    }
    
    value = attrs[@"fade"];
    if (value) {
        _fade = [VAConvertUtl convertToBOOL:value];
    }else if(isInit){
        _fade = true;
    }
    
    return needUpdate;

}
//填充样式
- (BOOL)_fillImageComponentStyles:(NSDictionary *)styles isInit:(BOOL)isInit{
    BOOL needUpdate = false;
    id value = styles[@"aspectRatio"];
    if (value) {
        CGFloat aspectRatio = [VAConvertUtl convertToFloat:value];
        if (aspectRatio != _aspectRatio) {
            _aspectRatio = aspectRatio;
            needUpdate = true;
        }
    }
    return needUpdate;
    
}


//加载图片
//
- (void)_syncImageToView{
    //
    NSDictionary * options = @{@"blurRadius":@(_blurRadius)};
    CGRect frame = self.componentFrame;
    UIViewContentMode mode = _contentMode;
    kBlockWeakSelf;
    __weak typeof(&*_imageView) weakImageView =  _imageView;

    //url先来
    
    
    BOOL urlEqual = [self _isUrlEqual:_url url1:_imageOperation.imageUrl];
    
    if (!urlEqual || _imageOperation.error) {
        //
        [_imageOperation cancel];
        if (weakImageView && weakImageView.image != _placeHolderImageOperation.image) {
            UIImage * newImage = _placeHolderImageOperation.image;
            UIImage * originImage = weakImageView.image;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.2) * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                if (weakImageView.image == originImage ) {
                    weakImageView.image = newImage;
                }
            });
            
          
        }
        _imageOperation = nil;
        if (_url.length) {
            NSString * url = _url;
            _imageOperation = [[self _getImageHanddler] downloadImageWithUrl:url contentMode:mode imageFrame:frame options:options completed:^(UIImage *image, NSError *error, BOOL finished) {
                if ([weakSelf _isUrlEqual:url url1:weakSelf.url]) {
                    
                    if (weakSelf.imageOperation == nil) {
                        dispatch_async([VAThreadManager getComponentQueue], ^{
                            weakSelf.imageOperation.image = image;
                            weakSelf.imageOperation.error = error;
                        });
                    }else {
                        [VAThreadManager performOnComponentThreadWithBlock:^{
                            weakSelf.imageOperation.image = image;
                            weakSelf.imageOperation.error = error;
                        }];
                    }
                    if ([weakSelf isViewLoaded]) {
                        [VAThreadManager performOnMainThreadWithBlock:^{
                            [weakSelf _setImageViewWithImage:image isPlaceHolder:false requestUrl:url curUrl:weakSelf.url];
                        }];
                    }else {
                        
                        [weakSelf addTaskToMainQueueOnComponentThead:^{
                            [weakSelf _setImageViewWithImage:image isPlaceHolder:false requestUrl:url curUrl:weakSelf.url];
                        }];
                    }
                }
            }];
            _imageOperation.imageUrl = url;
        }
        
        
    }
    
    
    
    
    
    //_url
    BOOL placeHolderUlrEqual = [self _isUrlEqual:_placeholderUrl url1:_placeHolderImageOperation.imageUrl];
    if (!placeHolderUlrEqual || _placeHolderImageOperation.error) {
        //赶紧下载一波
        [_placeHolderImageOperation cancel];//取消
        if (weakImageView && weakImageView.image == _placeHolderImageOperation.image) {
            UIImage * originImage = weakImageView.image;
            [VAThreadManager performOnMainThreadWithBlock:^{
                if (weakImageView.image == originImage ) {
                   weakImageView.image = nil;
                }
            }];
        }
        _placeHolderImageOperation = nil;
        if (_placeholderUrl.length) {
            NSString * placeHolderUrl = _placeholderUrl;
            _placeHolderImageOperation = [[self _getImageHanddler] downloadImageWithUrl:placeHolderUrl contentMode:mode imageFrame:frame options:options completed:^(UIImage *image, NSError *error, BOOL finished) {
                if ([weakSelf _isUrlEqual:placeHolderUrl url1:weakSelf.placeholderUrl]) {
                    
                    if (weakSelf.placeHolderImageOperation == nil) {
                        dispatch_async([VAThreadManager getComponentQueue], ^{
                            weakSelf.placeHolderImageOperation.image = image;
                            weakSelf.placeHolderImageOperation.error = error;
                        });
                    }else {
                        [VAThreadManager performOnComponentThreadWithBlock:^{
                            weakSelf.placeHolderImageOperation.image = image;
                            weakSelf.placeHolderImageOperation.error = error;
                        }];
                    }
                    if ([weakSelf isViewLoaded]) {
                        [VAThreadManager performOnMainThreadWithBlock:^{
                             [weakSelf _setImageViewWithImage:image isPlaceHolder:true requestUrl:placeHolderUrl curUrl:weakSelf.placeholderUrl];
                        }];
                    }else {
                        [weakSelf addTaskToMainQueueOnComponentThead:^{
                             [weakSelf _setImageViewWithImage:image isPlaceHolder:true requestUrl:placeHolderUrl curUrl:weakSelf.placeholderUrl];
                        }];
                    }
                }
            }];
            _placeHolderImageOperation.imageUrl = placeHolderUrl;
        }
    }
}
//设置下载回来的图片
- (void)_setImageViewWithImage:(UIImage *)image isPlaceHolder:(BOOL)isPlaceHolder requestUrl:(NSString *)rUrl curUrl:(NSString *)cUrl{
    VAAssertMainThread();
    if (![self _isUrlEqual:rUrl url1:cUrl]) {
        return ;
    }
    //后期会对setImage做动画
    //一期先做淡入动画
    if (isPlaceHolder) {
        if (self.imageView.image == nil) {
            if (_fade) {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.1;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [self.imageView.layer addAnimation:transition forKey:@"VAImageComponentFadeAnimationKey"];
            }
            self.imageView.image = image;
        }
    }else {
        if (self.imageView.image != image) {
            if (_fade) {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.2;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [self.imageView.layer addAnimation:transition forKey:@"VAImageComponentFadeAnimationKey"];
            }
              self.imageView.image = image;
        }

    }
}


- (id<VAImageHandlerProtocol>)_getImageHanddler{
    static id<VAImageHandlerProtocol> imageHandler;
    static dispatch_once_t onceToken;
    if (!imageHandler) {
        dispatch_once(&onceToken, ^{
            imageHandler = [VARegisterManager handlerWithProtocol:@protocol(VAImageHandlerProtocol)];
        });
    }
    return imageHandler;
}

- (BOOL)  _isUrlEqual:(NSString *)url0  url1:(NSString *)url1{
    if (url0 == nil && url1 == nil) return true;
    if (url0.length != url1.length) {//性能更快
        return false;
    }
    if (url0 == url1) {
        return true;
    }
    return [url0 isEqualToString:url1];
}



@end
