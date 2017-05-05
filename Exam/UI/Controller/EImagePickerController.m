//
//  EImagePickerController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/5.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EImagePickerController.h"
#import "UINavigationBar+Awesome.h"

@interface EImagePickerController ()

@end

@implementation EImagePickerController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customBar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customBar {
    self.navigationBar.barTintColor = kThemeColor; // 导航条颜色
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName, nil]; // 导航条标题属性
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.navigationBar lt_setBackgroundColor:kThemeColor];
    // 去掉导航的黑色边框线条效果 【设置了shodowImage就必须设置backgroundImage，否则无效】
    [self.navigationBar setShadowImage:[UIImage new]];
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
