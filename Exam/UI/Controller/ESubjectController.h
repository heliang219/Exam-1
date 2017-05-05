//
//  ESubjectController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseTableController.h"
@class ESubject;

/**
 科目
 */
@interface ESubjectController : EBaseTableController

- (instancetype)initWithSubject:(ESubject *)subject;

@end
