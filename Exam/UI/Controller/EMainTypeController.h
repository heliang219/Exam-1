//
//  EMainTypeController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"
#import "ESubjectController.h"

/**
 工种
 */
@interface EMainTypeController : EBaseController

- (instancetype)initWithSubjectType:(ESubjectType)type;

@end
