//
//  EAboutController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/5.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EAboutController.h"
#import "UILabel+Additions.h"

@interface EAboutController ()

@end

@implementation EAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于腾飞安培";
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNavigationBar {
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame = CGRectMake(0, 0, 24, 24);
    [goBackBtn setImage:IMAGE_BY_NAMED(@"setting_back") forState:UIControlStateNormal];
    [goBackBtn setImage:IMAGE_BY_NAMED(@"setting_back") forState:UIControlStateHighlighted];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
}

- (void)initScrollView {
    UIScrollView *scrollPane = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    scrollPane.contentSize = CGSizeMake(scrollPane.bounds.size.width, scrollPane.bounds.size.height - kNavigationBarHeight);
    scrollPane.showsVerticalScrollIndicator = NO;
    scrollPane.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollPane];
    
    CGFloat originX = kEPadding * 2;
    CGFloat originY = kEPadding * 4;
    
    UILabel *topLbl = [[UILabel alloc] init];
    topLbl.text = @"腾飞安培成立于2002年，是四川省属的B级培训机构。十余年来，公司依托西南交通大学雄厚的教学资源，励精图治，建立起九大门类数十个科目的安全培训体系，树立了优异的业界口碑。\n\n\n\n公司地址：成都市某路某大厦7层201\n公司电话：021-6570179";
    topLbl.textColor = [UIColor blackColor];
    topLbl.font = [UIFont systemFontOfSize:14.f];
    topLbl.numberOfLines = 100;
    [scrollPane addSubview:topLbl];
    
    CGFloat textHeight = [UILabel getHeightByWidth:kFrameWidth - originX * 2 title:topLbl.text font:topLbl.font];
    topLbl.frame = CGRectMake(originX, originY, kFrameWidth - originX * 2, textHeight);
    
    originY += textHeight + kEPadding * 10;
    UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionBtn.frame = CGRectMake(originX, originY, kFrameWidth - originX * 2, 40);
    attentionBtn.backgroundColor = RGBCOLOR(141, 203, 96);
    [attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [attentionBtn setTitle:@"关注腾飞安培" forState:UIControlStateNormal];
    attentionBtn.titleLabel.font = kBigFont;
    attentionBtn.layer.cornerRadius = 5.f;
    attentionBtn.layer.masksToBounds = YES;
    [attentionBtn addTarget:self action:@selector(attentionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollPane addSubview:attentionBtn];
}

- (void)attentionBtnAction {
    DLog(@"关注腾飞安培");
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
