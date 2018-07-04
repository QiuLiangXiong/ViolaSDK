//
//  VABaseViewController.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/3.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VABaseViewController.h"


@interface VABaseViewController ()<ViolaInstanceDelegate>


@property (nullable, nonatomic, strong) NSString * bundle;

@end

@implementation VABaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _instance = [[ViolaInstance alloc] init];
        _instance.delegate = self;
      
        // self.navigationController.navigationBar.hidden = true;
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"viola_test" ofType:@"js"];
//        NSString * script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        
        
      //  [_instance renderViewWithScript:script data:@{@"os":@"iOS"}];
    }
    return self;
}

#pragma mark - ViolaInstanceDelegate

- (void)violaIntance:(ViolaInstance *)instance didCreatedView:(UIView *)view{
    [self.view addSubview:view];
}

// 更新生命周期 todo tomqiu





- (void)viewDidLoad {
    [super viewDidLoad];
    self.instance.instanceFrame = self.view.frame;
    // Do any additional setup after loading the view.
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.instance.instanceFrame = self.view.frame;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSDictionary *)getGlobalData{
    return nil;
}


- (void)dealloc{
    [_instance destroyInstance];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
