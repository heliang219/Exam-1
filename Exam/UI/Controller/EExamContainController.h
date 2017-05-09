//
//  EExamContainController.h
//  Exam
//
//  Created by yongqingguo on 2017/1/20.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EExamContainController : UIViewController

- (instancetype)initWithQuestions:(NSArray *)questions;

- (instancetype)initWithTitle:(NSString *)title questions:(NSArray *)questions orientationWanted:(UIInterfaceOrientation)ori;

@end
