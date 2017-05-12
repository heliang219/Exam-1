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

@interface ERegisterController ()
{
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
    UIScrollView *scrollPane = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight + kEPadding, kFrameWidth, kFrameHeight - (kHeaderViewHeight + kEPadding))];
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
    ECheckTextField *nameTf = [[ECheckTextField alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - originX * 2, barHeight)];
    nameTf.font = kMediumFont;
    nameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollPane addSubview:nameTf];
    
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
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eyeBtn.frame = CGRectMake(0, 0, 20, 20);
    [eyeBtn setBackgroundImage:IMAGE_BY_NAMED(@"Icon") forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(eyeButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
}

- (void)registerBtnAction {
    DLog(@"注册");
//    BOOL idCardOK = [_idTf check:ETextFieldTypeIDCard];
//    BOOL phoneOK = [_phoneTf check:ETextFieldTypePhone];
//    if (idCardOK && phoneOK) {
        ERegisterSuccessController *registerSuccess = [[ERegisterSuccessController alloc] init];
        [self.navigationController pushViewController:registerSuccess animated:YES];
//    }
}

- (void)loginAction {
    DLog(@"登录");
    ELoginController *loginController = [[ELoginController alloc] init];
    [self.navigationController pushToController:loginController animated:YES];
}

- (void)eyeButtonAction {
    DLog(@"eye");
    _idTf.secureTextEntry = !_idTf.secureTextEntry;
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
