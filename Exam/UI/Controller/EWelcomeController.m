//
//  EWelcomeController.m
//  Exam
//
//  Created by gyq on 2017/1/19.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EWelcomeController.h"
#import "AppDelegate.h"

#define btnWidth 80.f

@interface EWelcomeController ()

@end

@implementation EWelcomeController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kThemeColor;
    
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame = CGRectMake((kFrameWidth - btnWidth) / 2, kFrameHeight - 200, btnWidth, btnWidth);
    [enterBtn setTitle:@"进入" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterBtn.titleLabel.font = kMediumFont;
    enterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    enterBtn.layer.borderWidth = 1.f;
    enterBtn.layer.cornerRadius = btnWidth / 2;
    enterBtn.layer.masksToBounds = YES;
    [enterBtn addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
}
            
- (void)enter {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate switchToLoginRegisterController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
