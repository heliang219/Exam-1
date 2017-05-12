//
//  ELoginController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/3.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "ELoginController.h"
#import "ECheckTextField.h"
#import "ERegisterController.h"
#import "AppDelegate.h"
#import "EAlertWindow.h"

@interface ELoginController ()<EAlertWindowDelegate>
{
    ECheckTextField *_phoneTf;
    ECheckTextField *_verifyTf;
    UIButton *_verifyBtn;
    NSTimer *timer;
    NSString *randomNumber;
    NSInteger seconds;
}

@end

@implementation ELoginController

- (void)dealloc {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNavigationBar {
    
}

- (void)initScrollView {
    UIScrollView *scrollPane = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight + kEPadding, kFrameWidth, kFrameHeight - (kHeaderViewHeight + kEPadding))];
    scrollPane.contentSize = scrollPane.bounds.size;
    scrollPane.showsVerticalScrollIndicator = NO;
    scrollPane.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollPane];
    
    CGFloat originX = kEPadding * 3;
    CGFloat originY = kEPadding * 4;
    
    CGFloat barHeight = 45.f;
    CGFloat lblHeight = 20.f;
    
    UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 100, lblHeight)];
    phoneLbl.text = @"手机号";
    phoneLbl.font = kSmallFont;
    
    [scrollPane addSubview:phoneLbl];
    
    originY += lblHeight + 9;
    _phoneTf = [[ECheckTextField alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - originX * 2, barHeight)];
    _phoneTf.font = kMediumFont;
    _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTf.immediatelyCheck = YES;
    [scrollPane addSubview:_phoneTf];
    
    originY += barHeight + 20;
    UILabel *verifyLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 100, lblHeight)];
    verifyLbl.text = @"验证码";
    verifyLbl.font = kSmallFont;
    [scrollPane addSubview:verifyLbl];
    
    originY += lblHeight + 9;
    _verifyTf = [[ECheckTextField alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - originX * 2 - 105, barHeight)];
    _verifyTf.font = kMediumFont;
    _verifyTf.keyboardType = UIKeyboardTypeNumberPad;
    [scrollPane addSubview:_verifyTf];
    
    originX += _verifyTf.bounds.size.width + 5;
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectMake(originX, originY, 100, barHeight);
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verifyBtn.backgroundColor = kThemeColor;
    [_verifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _verifyBtn.titleLabel.font = kSmallFont;
    _verifyBtn.layer.cornerRadius = 5.f;
    _verifyBtn.layer.masksToBounds = YES;
    [_verifyBtn addTarget:self action:@selector(verifyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:_verifyBtn];
    
    originX = kEPadding * 3;
    originY += barHeight * 2;
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(originX, originY, kFrameWidth - originX * 2, barHeight);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = kBigFont;
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 5.f;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = kThemeColor;
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:loginBtn];
    
    originX = kFrameWidth - 120.f;
    originY += barHeight + kEPadding;
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(originX, originY, 100, lblHeight);
    [registerBtn setTitle:@"未注册过？" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = kTinyFont;
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registerBtn setTitleColor:RGBCOLOR(87, 142, 249) forState:UIControlStateNormal];
    registerBtn.backgroundColor = [UIColor clearColor];
    [registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:registerBtn];
}

- (void)registerBtnAction {
    DLog(@"注册");
    ERegisterController *registerController = [[ERegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)loginBtnAction {
    DLog(@"登录");
    EAlertWindow *alertWindow = [EAlertWindow sharedWindow];
    alertWindow.style = EAlertWindowStyleCustom;
    alertWindow.titleFont = [UIFont boldSystemFontOfSize:25.f];
    alertWindow.bgColor = [UIColor whiteColor];
    alertWindow.confirmBtnBgColor = kThemeColor;
    alertWindow.confirmBtnTitleColor = [UIColor blackColor];
    alertWindow.btnInset = UIEdgeInsetsMake(0, kEPadding, kEPadding, kEPadding);
    alertWindow.delegate = self;
    [alertWindow showWithTitle:@"您的账号已被激活!" cancelTitle:nil confirmTitle:@"选择两项科目"];
}

- (void)verifyBtnAction {
    DLog(@"获取验证码");
    _verifyBtn.backgroundColor = RGBCOLOR(190, 191, 192);
    _verifyBtn.enabled = NO;
    [_verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    int num = (arc4random() % 10000);
    randomNumber = [NSString stringWithFormat:@"%.4d", num];
    DLog(@"验证码：%@", randomNumber);
    seconds = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)changeSeconds {
    seconds --;
    if (seconds <= 0) {
        _verifyBtn.backgroundColor = kThemeColor;
        _verifyBtn.enabled = YES;
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
        randomNumber = 0;
    } else {
        [_verifyBtn setTitle:[NSString stringWithFormat:@"%@s后重试",@(seconds)] forState:UIControlStateNormal];
    }
}

#pragma mark - EAlertWindowDelegate

- (void)eAlertWindow:(EAlertWindow *)alertWindow didClickedAtIndex:(NSInteger)index {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate switchToNavigationController];
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
