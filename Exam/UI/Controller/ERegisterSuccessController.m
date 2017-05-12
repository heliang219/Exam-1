//
//  ERegisterSuccessController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "ERegisterSuccessController.h"
#import "EAlertWindow.h"
#import "ELoginController.h"

#define logo_success_width 104

@interface ERegisterSuccessController ()<EAlertWindowDelegate>

@end

@implementation ERegisterSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册成功";
    [self initContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initContentView {
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((kFrameWidth - logo_success_width) / 2, kNavigationBarHeight + logo_success_width, logo_success_width, logo_success_width)];
    logo.image = IMAGE_BY_NAMED(@"registerSuccess_logo");
    [self.view addSubview:logo];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake((kFrameWidth - 200) / 2.f, logo.frame.origin.y + logo.bounds.size.height + 36, 200, 40)];
    lbl.text = @"感谢您注册!";
    lbl.textColor = [UIColor blackColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont boldSystemFontOfSize:30.f];
    [self.view addSubview:lbl];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((kFrameWidth - 200) / 2.f, lbl.frame.origin.y + lbl.bounds.size.height + 22, 200, 20);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"您当前的版本：试用版"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 7)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(87, 142, 251) range:NSMakeRange(7, 3)];
    [attrStr addAttribute:NSFontAttributeName value:kSmallFont range:NSMakeRange(0, 10)];
    [btn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnAction {
    DLog(@"试用版");
    EAlertWindow *alertWindow = [EAlertWindow sharedWindow];
    alertWindow.style = EAlertWindowStyleCustom;
    alertWindow.bgColor = [UIColor clearColor];
    alertWindow.confirmBtnBgColor = kThemeColor;
    alertWindow.confirmBtnTitleColor = [UIColor blackColor];
    alertWindow.btnInset = UIEdgeInsetsMake(0, kEPadding, kEPadding, kEPadding);
    alertWindow.delegate = self;
    [alertWindow showWithTitle:@"试用版软件的模拟练习次数将会受到限制，最多只能进行5次模拟练习，您可以在软件的设置界面中查看剩余练习次数。当报名参加我公司培训时，软件将自动激活成为正式版。正式版软件可进行不限次数的模拟练习。" cancelTitle:nil confirmTitle:@"知道了"];
}

#pragma mark - EAlertWindowDelegate

- (void)eAlertWindow:(EAlertWindow *)alertWindow didClickedAtIndex:(NSInteger)index {
    if (index == 0) { // 取消
        
    } else { // 确定
        ELoginController *loginController = [[ELoginController alloc] init];
        [self.navigationController pushToController:loginController animated:YES];
    }
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
