//
//  TestViewController.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/6/26.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "TestViewController.h"
#import "ViolaSDK.h"

@interface TestViewController ()<ViolaInstanceDelegate>

@property (nullable, nonatomic, strong) ViolaInstance * vaInstance;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ViolaInstance * intance = [ViolaInstance new];
    intance.delegate = self;
    self.vaInstance = intance;
    intance.instanceFrame = self.view.frame;
    
    
   // self.navigationController.navigationBar.hidden = true;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"viola_test" ofType:@"js"];
    NSString * script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    

  
    [intance renderViewWithScript:script data:@{@"os":@"iOS"}];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [VAThreadManager waitUntilViolaIntanceRenderFinish];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGRect dfd = self.view.frame;
    
    self.vaInstance.instanceFrame = self.view.frame;
}

#pragma mark - ViolaInstanceDelegate

- (void)violaIntance:(ViolaInstance *)instance didCreatedView:(UIView *)view{
    [self.view addSubview:view];
}


- (void)dealloc{
    [self.vaInstance destroyInstance];
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
