//
//  ESubjectController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"
@class ESubject;

typedef NS_ENUM(NSInteger,ESubjectType) {
    ESubjectTypeNormal,
    ESubjectTypeSelection,
};

/**
 科目
 */
@interface ESubjectController : EBaseController

- (instancetype)initWithSubject:(ESubject *)subject;

- (instancetype)initWithSubject:(ESubject *)subject type:(ESubjectType)type;

- (instancetype)initWithContentArray:(NSMutableArray *)contentArray type:(ESubjectType)type;

@end
