//
//  EExamContainController.h
//  Exam
//
//  Created by yongqingguo on 2017/1/20.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EQuestion.h"

@interface EExamContainController : UIViewController

- (instancetype)initWithQuestions:(NSArray *)questions;

- (instancetype)initWithTitle:(NSString *)title questions:(NSArray *)questions orientationWanted:(UIInterfaceOrientation)ori;

- (void)refreshQuestion:(EQuestion *)question lock:(BOOL)lock;

@end
