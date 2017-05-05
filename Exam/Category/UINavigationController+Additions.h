//
//  UINavigationController+Additions.h
//  Exam
//
//  Created by yongqingguo on 2017/5/3.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Additions)

/**
 页面导航，如果栈中没有则push，如果栈中已有，则pop

 @param controller 要跳转到的页面
 @param animated 是否需要动画效果
 */
- (void)pushToController:(UIViewController *)controller animated:(BOOL)animated;

@end
