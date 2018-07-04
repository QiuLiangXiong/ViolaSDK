//
//  ViewController.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/6/21.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "ViewController.h"
#import "ViolaSDK.h"
#import "TestViewController.h"

@interface ViewController ()<ViolaInstanceDelegate>

@property (nullable, nonatomic, strong) ViolaInstance * vaInstance;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

        [ViolaEngine startEngineIfNeed];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    ViolaInstance * intance = [ViolaInstance new];
//    intance.delegate = self;
//    self.vaInstance = intance;
//    intance.instanceFrame = self.view.frame;
//
//
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"viola_test" ofType:@"js"];
//    NSString * script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//
//    script = @"callNative('1',[{module:'dom',method:'createBody',args:[{attr:{}}]}])";
//
//    [intance renderViewWithScript:script data:@{@"os":@"iOS"}];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * jumpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    jumpBtn.center = CGPointMake(self.view.frame.size.width/2 , self.view.frame.size.height / 2);
    [jumpBtn setTitle:@"push" forState:(UIControlStateNormal)];
    jumpBtn.backgroundColor = [UIColor blueColor];
    [jumpBtn addTarget:self action:@selector(onClickJumpBtnWithSender:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
    
}

#pragma mark - action

- (void)onClickJumpBtnWithSender:(UIButton *)sender{
    TestViewController * vc = [TestViewController new];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - ViolaInstanceDelegate

- (void)violaIntance:(ViolaInstance *)instance didCreatedView:(UIView *)view{
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
