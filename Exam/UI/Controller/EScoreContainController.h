//
//  EScoreContainController.h
//  Exam
//
//  Created by yongqingguo on 2017/2/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EExam.h"

@interface EScoreContainController : UIViewController

- (instancetype)initWithTitle:(NSString *)title questions:(NSArray *)questions exam:(EExam *)exam;

@end
