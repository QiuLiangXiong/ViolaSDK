//
//  VABaseViewController.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/3.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VABaseViewController.h"
#import "VAThreadManager.h"
#import "ViolaEngine.h"


@interface VABaseViewController ()


@property (nonatomic, assign) BOOL renderScripting;
@property (nonatomic, assign) int willAppearTimes;


@end

@implementation VABaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _instance = [[ViolaInstance alloc] init];
        _instance.viewController = self;
        _instance.delegate = self;
        _instance.instanceFrame = self.view.frame;
        [ViolaEngine startEngineIfNeed];

        // self.navigationController.navigationBar.hidden = true;
    }
    return self;
}

#pragma mark - public

- (void)renderWithJSScript:(NSString *)script  pageParam:(NSDictionary *)param{
    if (script.length) {
        self.renderScripting = true;
        [self.instance renderViewWithScript:script data:param];
    }

}


#pragma mark - ViolaInstanceDelegate

- (void)violaIntance:(ViolaInstance *)instance didCreatedView:(UIView *)view{
    [self.view addSubview:view];
}

- (void)renderFinishWithViolaIntance:(ViolaInstance *)instance{
    self.renderScripting = false;
}



#pragma mark - cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.instance.instanceFrame = self.view.frame;
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.willAppearTimes++;
    if (self.willAppearTimes <= 1 && self.renderScripting) {
        [VAThreadManager waitUntilViolaIntanceRenderFinish];
        

        self.view.backgroundColor = self.instance.rootViewBackgroundColor;
        self.instance.rootView.alpha = 0;
        [UIView animateWithDuration:0.1 animations:^{
            self.instance.rootView.alpha = 1;
        }];
        
        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//
//        });
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_instance refreshInstance:@{@"viewDidAppear":@1}];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_instance refreshInstance:@{@"viewDidDisappear":@1}];
}




- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.instance.instanceFrame = self.view.frame;
}



- (void)dealloc{
    [_instance destroyInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
