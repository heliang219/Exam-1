//
//  ESettingController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "ESettingController.h"
#import "EUploadIDCardController.h"

@interface ESettingController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@end

@implementation ESettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self initTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn; // 可更改为其他方式
    transition.subtype = kCATransitionFromBottom; // 可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTable {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setTableFooterView:[self buildTableFooter]];
    [self.view addSubview:_tableView];
}

- (UIView *)buildTableFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 100)];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kEPadding * 2, kEPadding * 3, footer.bounds.size.width - kEPadding * 4, footer.bounds.size.height - kEPadding * 6);
    [shareBtn setTitle:@"软件分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.backgroundColor = kThemeColor;
    shareBtn.titleLabel.font = kBigFont;
    shareBtn.layer.cornerRadius = 5.f;
    shareBtn.layer.masksToBounds = YES;
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:shareBtn];
    
    return footer;
}

- (void)shareBtnAction {
    DLog(@"软件分享");
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            EUploadIDCardController *uploadIDCardController = [[EUploadIDCardController alloc] init];
            [self.navigationController pushToController:uploadIDCardController animated:YES];
        } else if (indexPath.row == 2) {
            
        } else {
            
        }
    } else {
        if (indexPath.row == 0) {
            
        } else {
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"使用者姓名";
            cell.detailTextLabel.text = @"张三";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"身份证上传";
            cell.detailTextLabel.text = @"未上传";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"我的题库";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"剩余练习次数";
            cell.detailTextLabel.text = @"3次";
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关于腾飞安培";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"软件更新";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
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
