//
//  EPreparationController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseTableController.h"
@class ESubject;

/**
 考试准备
 */
@interface EPreparationController : EBaseTableController

- (instancetype)initWithSubject:(ESubject *)subject parentSubject:(ESubject *)pSubject;

@end
