//
//  VABaseViewController.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/3.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VABaseViewController.h"
#import "ViolaInstance.h"

@interface VABaseViewController ()

@property (nullable, nonatomic, strong) ViolaInstance * instance;
@property (nullable, nonatomic, strong) NSString * bundle;

@end

@implementation VABaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}


- (instancetype)initWithSourceUrl:(NSString *)sourceUrl;
{
    if ((self = [self init])) {
        
    }
    return self;
}

- (instancetype)initWithSourceUrl:(NSString *)sourceUrl data:(NSDictionary *)data{
    if (self = [self initWithSourceUrl:sourceUrl]) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            //self.data = data;
            
        }
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
