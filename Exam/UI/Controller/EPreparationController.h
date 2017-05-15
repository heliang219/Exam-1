//
//  EPreparationController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"
@class ESubject;

/**
 考试准备
 */
@interface EPreparationController : EBaseController

- (instancetype)initWithSubject:(ESubject *)subject parentSubject:(ESubject *)pSubject;

@end
