//
//  VAViewController.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/4.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAViewController.h"
#import "VABundleManager.h"
#import "VADefine.h"

@interface VAViewController()

@property (nullable, nonatomic, copy) NSString * sourceUrl;
@property (nullable, nonatomic, strong) NSDictionary * pageParam;

@end

@implementation VAViewController


- (instancetype)initWithSourceUrl:(NSString * _Nonnull)url pageParam:(NSDictionary * _Nullable)param{
    if (self = [super init]) {
        _sourceUrl = url;
        _pageParam = param;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
     VAAssert(_sourceUrl, @"can't be nil");
    //先判断本地是否存在该脚本
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString * script = [[VABundleManager shareManager] getLocalScriptWithUrl:_sourceUrl];
    
    if (script.length) {
        [self renderWithJSScript:script pageParam:_pageParam];
    }else {
        //开始网络请求
        //
        kBlockWeakSelf;
        //加载中 这边等待loading效果
        [[VABundleManager shareManager] downloadJSFileWithUrl:_sourceUrl completedBlocK:^(NSString * _Nullable script, NSError * _Nullable error) {
            if (script.length) {
                [weakSelf renderWithJSScript:script pageParam:_pageParam];
                
            }else {
                //加载失败
            }
            
        }];

    }
    

    
   
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"viola_test" ofType:@"js"];
//    NSString * script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

}



@end
