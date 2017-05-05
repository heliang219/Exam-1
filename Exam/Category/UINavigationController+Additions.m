//
//  UINavigationController+Additions.m
//  Exam
//
//  Created by yongqingguo on 2017/5/3.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "UINavigationController+Additions.h"

@implementation UINavigationController (Additions)

- (void)pushToController:(UIViewController *)controller animated:(BOOL)animated {
    BOOL isInStack = NO;
    UIViewController *tempController = controller;
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:controller.class]) {
            isInStack = YES;
            tempController = vc;
            break;
        }
    }
    if (isInStack) {
        [self popToViewController:tempController animated:animated];
    } else {
        [self pushViewController:tempController animated:YES];
    }
}

@end
