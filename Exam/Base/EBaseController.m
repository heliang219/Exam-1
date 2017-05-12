//
//  EBaseController.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"

@interface EBaseController ()

@end

@implementation EBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    
    [self configNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)configNavigationBar {
    // 交给子类去实现
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame = CGRectMake(0, 0, 20, 20);
    [goBackBtn setImage:IMAGE_BY_NAMED(@"back") forState:UIControlStateNormal];
    [goBackBtn setImage:IMAGE_BY_NAMED(@"back") forState:UIControlStateHighlighted];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
}

#pragma mark - UIButtonAction

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
