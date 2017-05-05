//
//  EExerciseListController.h
//  Exam
//
//  Created by gyq on 2017/1/19.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"
@class ESubject;

/**
 习题列表
 */
@interface EExerciseListController : EBaseController

- (instancetype)initWithSubject:(ESubject *)subject;

@end
