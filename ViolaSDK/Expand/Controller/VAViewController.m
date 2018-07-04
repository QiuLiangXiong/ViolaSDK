//
//  VAViewController.m
//  ViolaSDK
//
//  Created by 邱良雄 on 2018/7/4.
//  Copyright © 2018年 邱良雄. All rights reserved.
//

#import "VAViewController.h"

@implementation VAViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"viola_test" ofType:@"js"];
    NSString * script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self renderWithJSScript:script pageParam:@{}];
}

@end
