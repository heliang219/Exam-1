//
//  EUpdateController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/5.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EUpdateController.h"
#import "UINavigationBar+Awesome.h"

@interface EUpdateController ()
{
    UILabel *_titleLbl1;
    UILabel *_titleLbl2;
    UIProgressView *_progressView1;
    UIProgressView *_progressView2;
    UILabel *_progressLbl1;
    UILabel *_progressLbl2;
}

@end

@implementation EUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更新";
    [self initContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
}

- (void)configNavigationBar {
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame = CGRectMake(0, 0, 24, 24);
    [goBackBtn setImage:IMAGE_BY_NAMED(@"setting_back") forState:UIControlStateNormal];
    [goBackBtn setImage:IMAGE_BY_NAMED(@"setting_back") forState:UIControlStateHighlighted];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
}

- (void)initContentView {
    CGFloat originX = kEPadding * 2;
    CGFloat originY = kNavigationBarHeight + kEPadding * 4;
    
    _titleLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - originX * 2, 20)];
    _titleLbl1.text = @"题库更新正在进行，请稍后...";
    _titleLbl1.backgroundColor = [UIColor clearColor];
    _titleLbl1.textColor = [UIColor blackColor];
    _titleLbl1.font = kSmallFont;
    [self.view addSubview:_titleLbl1];
    
    originY += _titleLbl1.bounds.size.height + kEPadding * 2;
    _progressView1 = [[UIProgressView alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - 70, kEPadding)];
    _progressView1.progressTintColor = RGBCOLOR(95, 139, 228);
    _progressView1.trackTintColor = RGBCOLOR(184, 190, 196);
    _progressView1.progress = 0.3;
    _progressView1.progressViewStyle = UIProgressViewStyleDefault;
    [self.view addSubview:_progressView1];
    
    originX = kFrameWidth - 60;
    _progressLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 60, 20)];
    _progressLbl1.text = @"70%";
    _progressLbl1.textAlignment = NSTextAlignmentCenter;
    _progressLbl1.backgroundColor = [UIColor clearColor];
    _progressLbl1.textColor = RGBCOLOR(95, 139, 228);
    _progressLbl1.font = kSmallFont;
    [self.view addSubview:_progressLbl1];
    
    originX = kEPadding * 2;
    originY += _progressView1.bounds.size.height + kEPadding * 10;
    _titleLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - originX * 2, 20)];
    _titleLbl2.text = @"App当前版本1.20";
    _titleLbl2.backgroundColor = [UIColor clearColor];
    _titleLbl2.textColor = [UIColor blackColor];
    _titleLbl2.font = kSmallFont;
    [self.view addSubview:_titleLbl2];
    
    originY += _titleLbl2.bounds.size.height + kEPadding * 2;
    _progressView2 = [[UIProgressView alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - 70, kEPadding)];
    _progressView2.progressTintColor = RGBCOLOR(95, 139, 228);
    _progressView2.trackTintColor = RGBCOLOR(184, 190, 196);
    _progressView2.progress = 1.0;
    _progressView2.progressViewStyle = UIProgressViewStyleDefault;
    [self.view addSubview:_progressView2];
    
    originX = kFrameWidth - 60;
    _progressLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 60, 20)];
    _progressLbl2.text = @"100%";
    _progressLbl2.textAlignment = NSTextAlignmentCenter;
    _progressLbl2.backgroundColor = [UIColor clearColor];
    _progressLbl2.textColor = RGBCOLOR(95, 139, 228);
    _progressLbl2.font = kSmallFont;
    [self.view addSubview:_progressLbl2];
    
    // 设置进度条高度
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 3.0);
    _progressView1.transform = transform;
    _progressView2.transform = transform;
    // 设置进度条两端弧度
    _progressView1.layer.cornerRadius = 3.f;
    _progressView1.layer.masksToBounds = YES;
    _progressView2.layer.cornerRadius = 3.f;
    _progressView2.layer.masksToBounds = YES;
    
    // 垂直对齐
    _progressLbl1.center = CGPointMake(_progressLbl1.center.x, _progressView1.center.y);
    _progressLbl2.center = CGPointMake(_progressLbl2.center.x, _progressView2.center.y);
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
