//
//  EBaseTableController.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseTableController.h"

@interface EBaseTableController ()

@end

@implementation EBaseTableController

#pragma Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init


/**
 初始化顶部logo视图
 */
- (void)initHeader {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kHeaderViewHeight)];
    headView.backgroundColor = kThemeColor;
    [self.view addSubview:headView];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((kFrameWidth - kLogoWidth) / 2, kNavigationBarHeight + kEPadding, kLogoWidth, kLogoHeight)];
    logo.image = IMAGE_BY_NAMED(@"logo");
    [headView addSubview:logo];
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
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
