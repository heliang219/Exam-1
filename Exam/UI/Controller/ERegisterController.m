//
//  ERegisterController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "ERegisterController.h"
#import "ECheckTextField.h"
#include "ERegisterSuccessController.h"
#import "ELoginController.h"
#import "EApiClient.h"
#import "NSString+Additions.h"

@interface ERegisterController ()
{
    ECheckTextField *_nameTf;
    ECheckTextField *_idTf;
    ECheckTextField *_phoneTf;
}

@end

@implementation ERegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 40, lblHeight)];
    nameLbl.text = @"姓名";
    nameLbl.font = kSmallFont;
    [scrollPane addSubview:nameLbl];
    
    originY += lblHeight + 9;
    _nameTf = [[ECheckTextField alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - originX * 2, barHeight)];
    _nameTf.font = kMediumFont;
    _nameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollPane addSubview:_nameTf];
    
    originY += barHeight + 15;
    UILabel *idLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 100, lblHeight)];
    idLbl.text = @"身份证号";
    idLbl.font = kSmallFont;
    [scrollPane addSubview:idLbl];
    
    originY += lblHeight + 9;
    _idTf = [[ECheckTextField alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - originX * 2, barHeight)];
    _idTf.font = kMediumFont;
    _idTf.secureTextEntry = YES;
    _idTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _idTf.immediatelyCheck = YES;
    _idTf.checkType = ETextFieldTypeIDCard;
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eyeBtn.frame = CGRectMake(0, 0, 20, 20);
    [eyeBtn setBackgroundImage:IMAGE_BY_NAMED(@"eye_closed") forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(eyeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _idTf.rightView = eyeBtn;
    [scrollPane addSubview:_idTf];
    
    originY += barHeight + 15;
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
    
    originY += barHeight * 2;
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(originX, originY, kFrameWidth - originX * 2, barHeight);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = kBigFont;
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerBtn.layer.cornerRadius = 5.f;
    registerBtn.layer.masksToBounds = YES;
    registerBtn.backgroundColor = kThemeColor;
    [registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:registerBtn];
    
    originX = kFrameWidth - 120.f;
    originY += barHeight + kEPadding;
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(originX, originY, 100, lblHeight);
    [loginBtn setTitle:@"已经注册过？" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = kTinyFont;
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [loginBtn setTitleColor:RGBCOLOR(87, 142, 249) forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor clearColor];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:loginBtn];
    
    scrollPane.contentSize = CGSizeMake(scrollPane.bounds.size.width, originY + lblHeight + 40);
}

- (void)registerBtnAction {
    BOOL idCardOK = [_idTf check:ETextFieldTypeIDCard];
    BOOL phoneOK = [_phoneTf check:ETextFieldTypePhone];
    NSString *name = [_nameTf.text realString];
    if (!name) {
        [self showTips:@"姓名不能为空" time:1 completion:nil];
    } else if (idCardOK && phoneOK) {
        [self startLoading:YES];
        WEAK
        [[EApiClient sharedClient] userRegister:name certificate:[_idTf.text realString] phone:[_phoneTf.text realString] completion:^(id responseObject, NSError *error) {
            STRONG
            [strongSelf startLoading:NO];
            if (responseObject) {
                ERegisterSuccessController *registerSuccess = [[ERegisterSuccessController alloc] init];
                [strongSelf.navigationController pushViewController:registerSuccess animated:YES];
            } else {
                NSString *info = error.userInfo[@"error"];
                [strongSelf showTips:info time:1 completion:nil];
            }
        }];
    }
}

- (void)loginAction {
    ELoginController *loginController = [[ELoginController alloc] init];
    [self.navigationController pushToController:loginController animated:YES];
}

- (void)eyeButtonAction:(UIButton *)btn {
    _idTf.secureTextEntry = !_idTf.secureTextEntry;
    [btn setBackgroundImage:IMAGE_BY_NAMED(_idTf.secureTextEntry?@"eye_closed":@"eye_open") forState:UIControlStateNormal];
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
