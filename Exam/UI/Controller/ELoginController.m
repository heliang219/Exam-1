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
#import "NSString+Additions.h"
#import "EApiClient.h"
#import "NSDictionary+Additions.h"
#import "EUtils.h"
#import "SDWebImageManager.h"

@interface ELoginController ()<EAlertWindowDelegate>
{
    ECheckTextField *_phoneTf;
    ECheckTextField *_verifyTf;
    UIButton *_verifyBtn;
    NSTimer *timer;
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
    UIScrollView *scrollPane = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight, kFrameWidth, kFrameHeight - kHeaderViewHeight)];
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
    _phoneTf.checkType = ETextFieldTypePhone;
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
    
    scrollPane.contentSize = CGSizeMake(scrollPane.bounds.size.width, originY + lblHeight + 40);
}

#pragma mark - UIButtonAction

- (void)registerBtnAction {
    ERegisterController *registerController = [[ERegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)loginBtnAction {
    BOOL phoneOK = [_phoneTf check:ETextFieldTypePhone];
    if (phoneOK) {
        NSString *validateCode = [_verifyTf.text realString];
        if (!validateCode) {
            [self showTips:@"请输入短信验证码" time:1 completion:nil];
        } else {
            [self startLoading:YES];
            WEAK
            [[EApiClient sharedClient] login:[_phoneTf.text realString] validateCode:validateCode completion:^(id responseObject, NSError *error) {
                STRONG
                [strongSelf startLoading:NO];
                if (responseObject) {
                    // 保存用户信息
                    NSInteger userId = [responseObject integerValueForKey:@"id" defaultValue:-1];
                    NSString *accessToken = [responseObject stringValueForKey:@"access_token" defaultValue:nil];
                    NSString *name = [responseObject stringValueForKey:@"name" defaultValue:nil];
                    NSString *phone = [responseObject stringValueForKey:@"phone" defaultValue:nil];
                    NSInteger trailCount = [responseObject integerValueForKey:@"trail_count" defaultValue:0];
                    NSDictionary *avatorDic = [responseObject dictionaryValueForKey:@"avatar" defaultValue:nil];
                    if (avatorDic) {
                        NSString *avatorUrl = [avatorDic stringValueForKey:@"url" defaultValue:nil];
                        avatorUrl = [[EApiClient sharedClient].baseUrl stringByAppendingString:avatorUrl];
                        [kUserDefaults setObject:avatorUrl forKey:kAvatorUrl];
                        [kUserDefaults synchronize];
                        // 保存图片到本地
                        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:avatorUrl] options:SDWebImageContinueInBackground progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                [EUtils saveLocalAvator:image];
                            } else {
                                [EUtils saveLocalAvator:IMAGE_BY_NAMED(@"setting_avator")];
                            }
                        }];
                    }
                    NSDictionary *certificate_frontDic = [responseObject dictionaryValueForKey:@"certificate_image_front" defaultValue:nil];
                    if (certificate_frontDic) {
                        NSString *frontUrl = [certificate_frontDic stringValueForKey:@"url" defaultValue:nil];
                        [kUserDefaults setObject:frontUrl forKey:kCertificateFront];
                        [kUserDefaults synchronize];
                    }
                    NSDictionary *certificate_backDic = [responseObject dictionaryValueForKey:@"certificate_image_back" defaultValue:nil];
                    if (certificate_backDic) {
                        NSString *backUrl = [certificate_backDic stringValueForKey:@"url" defaultValue:nil];
                        [kUserDefaults setObject:backUrl forKey:kCertificateBack];
                        [kUserDefaults synchronize];
                    }
                    [kUserDefaults setBool:YES forKey:kIsLogin];
                    [kUserDefaults synchronize];
                    [kUserDefaults setInteger:userId forKey:kUserId];
                    [kUserDefaults synchronize];
                    [kUserDefaults setObject:accessToken forKey:kAccess_Token];
                    [kUserDefaults synchronize];
                    [kUserDefaults setObject:name forKey:kName];
                    [kUserDefaults synchronize];
                    [kUserDefaults setObject:phone forKey:kPhone];
                    [kUserDefaults synchronize];
                    [kUserDefaults setInteger:trailCount forKey:kTrailCount];
                    [kUserDefaults synchronize];
                    NSArray *subjectsArr = [responseObject arrayValueForKey:@"selected_subjects" defaultValue:nil];
                    if (subjectsArr && subjectsArr.count > 0) {
                        [kUserDefaults setObject:subjectsArr forKey:kSelectedNumbers];
                        [kUserDefaults synchronize];
                    } else {
                        [kUserDefaults setObject:nil forKey:kSelectedNumbers];
                        [kUserDefaults synchronize];
                    }
                    // 激活状态
                    NSString *activateStatus = [responseObject stringValueForKey:@"activation_status" defaultValue:@""];
                    if ([activateStatus isEqualToString:@"trail"]) { // 未激活
                        DLog(@"账号未激活");
                    } else { // 已激活
                        DLog(@"账号已激活");
                    }
                    EAlertWindow *alertWindow = [EAlertWindow sharedWindow];
                    alertWindow.style = EAlertWindowStyleCustom;
                    alertWindow.icon = IMAGE_BY_NAMED(@"registerSuccess_logo");
                    alertWindow.titleFont = [UIFont boldSystemFontOfSize:24.f];
                    alertWindow.bgColor = [UIColor clearColor];
                    alertWindow.confirmBtnBgColor = kThemeColor;
                    alertWindow.confirmBtnTitleColor = [UIColor blackColor];
                    alertWindow.btnInset = UIEdgeInsetsMake(0, kEPadding, kEPadding, kEPadding);
                    alertWindow.delegate = self;
                    [alertWindow showWithTitle:@"您的账号已被激活!" cancelTitle:nil confirmTitle:@"选择两项科目"];
                } else {
                    NSString *info = error.userInfo[@"error"];
                    [strongSelf showTips:info time:1 completion:nil];
                }
            }];
        }
    }
}

/**
 禁止/允许‘获取验证码’按钮点击相应
 */
- (void)setEnableYanzhengmaBtn:(BOOL)enable {
    if (enable) {
        _verifyBtn.backgroundColor = kThemeColor;
        _verifyBtn.enabled = YES;
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        _verifyBtn.backgroundColor = RGBCOLOR(190, 191, 192);
        _verifyBtn.enabled = NO;
        [_verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)verifyBtnAction {
    BOOL phoneOK = [_phoneTf check:ETextFieldTypePhone];
    if (phoneOK) {
        [self setEnableYanzhengmaBtn:NO];
        WEAK
        [[EApiClient sharedClient] sendSMSCode:[_phoneTf.text realString] completion:^(id responseObject, NSError *error) {
            STRONG
            if (responseObject) {
                [strongSelf showTips:@"验证码已发送" time:1 completion:nil];
                strongSelf->_verifyTf.text = [responseObject stringValueForKey:@"verification_code" defaultValue:nil];
            } else {
                NSString *info = error.userInfo[@"error"];
                [strongSelf showTips:info time:1 completion:nil];
            }
        }];
        seconds = 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
        [timer fire];
    }
}

#pragma mark - other methods

- (void)changeSeconds {
    seconds --;
    if (seconds <= 0) {
        [self setEnableYanzhengmaBtn:YES];
        [timer invalidate];
        timer = nil;
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
