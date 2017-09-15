//
//  ENavigationController.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "ENavigationController.h"
#import "UINavigationBar+Awesome.h"
#import "EExamContainController.h"
#import "EExamPaneController.h"
#import "EScoreContainController.h"
#import "EScorePaneController.h"

@interface ENavigationController ()

@end

@implementation ENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航条颜色
    self.navigationBar.barTintColor = kThemeColor;
    // 修改导航条返回文字和箭头颜色
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    // 导航条标题属性
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18.f]};
    self.interactivePopGestureRecognizer.enabled = YES;
    // 去掉半透明效果【虽然可以设置translucent为NO,但是整体页面改动会很大。】
    [self.navigationBar lt_setBackgroundColor:kThemeColor];
    // 去掉导航的黑色边框线条效果 【设置了shodowImage就必须设置backgroundImage，否则无效】
    [self.navigationBar setShadowImage:[UIImage new]];
    // 禁止手势滑动返回
    [self addFullScreenPopBlackListItem:[EExamContainController new]];
    [self addFullScreenPopBlackListItem:[EExamPaneController new]];
    [self addFullScreenPopBlackListItem:[EScoreContainController new]];
    [self addFullScreenPopBlackListItem:[EScorePaneController new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
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
