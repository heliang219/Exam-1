//
//  EUploadIDCardController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EUploadIDCardController.h"

@interface EUploadIDCardController ()

@end

@implementation EUploadIDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份认证";
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initScrollView {
    UIScrollView *scrollPane = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    scrollPane.contentSize = CGSizeMake(scrollPane.bounds.size.width, scrollPane.bounds.size.height - kNavigationBarHeight);
    scrollPane.showsVerticalScrollIndicator = NO;
    scrollPane.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollPane];
    
    CGFloat originX = kEPadding * 5;
    CGFloat originY = kEPadding * 3;
    
    CGFloat blockWidth = kFrameWidth - originX * 2;
    CGFloat blockHeight = blockWidth / 2.f;
    CGFloat lblWidth = blockWidth;
    CGFloat lblHeight = 20.f;
    
    UILabel *topLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, lblWidth, lblHeight)];
    topLbl.text = @"上传身份证正面";
    topLbl.textColor = [UIColor blackColor];
    topLbl.textAlignment = NSTextAlignmentCenter;
    topLbl.font = kSmallFont;
    [scrollPane addSubview:topLbl];
    
    originY += lblHeight + kEPadding * 2;
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.frame = CGRectMake(originX, originY, blockWidth, blockHeight);
    [topBtn setBackgroundImage:IMAGE_BY_NAMED(@"Icon") forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(topBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:topBtn];
    
    originY += blockHeight + kEPadding * 4;
    UILabel *bottomLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, lblWidth, lblHeight)];
    bottomLbl.text = @"上传身份证反面";
    bottomLbl.textColor = [UIColor blackColor];
    bottomLbl.textAlignment = NSTextAlignmentCenter;
    bottomLbl.font = kSmallFont;
    [scrollPane addSubview:bottomLbl];
    
    originY += lblHeight + kEPadding * 2;
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(originX, originY, blockWidth, blockHeight);
    [bottomBtn setBackgroundImage:IMAGE_BY_NAMED(@"Icon") forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:bottomBtn];
    
    originX = kEPadding * 2;
    originY += blockHeight + kEPadding * 8;
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(originX, originY, kFrameWidth - originX * 2, 40);
    submitBtn.backgroundColor = kThemeColor;
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kBigFont;
    submitBtn.layer.cornerRadius = 5.f;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:submitBtn];
}

- (void)topBtnAction {
    DLog(@"上传身份证正面");
}

- (void)bottomBtnAction {
    DLog(@"上传身份证反面");
}

- (void)submitBtnAction {
    DLog(@"提交");
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
