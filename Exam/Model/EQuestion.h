//
//  EQuestion.h
//  Exam
//
//  Created by gyq on 2017/2/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 question
 */
@interface EQuestion : NSObject

@property (nonatomic,assign) NSInteger question_index;
@property (nonatomic,assign) NSInteger question_id;
@property (nonatomic,assign) NSInteger question_subject_id;
@property (nonatomic,copy) NSString *question_content;
@property (nonatomic,copy) NSString *question_type;
@property (nonatomic,assign) NSInteger question_case_id;
@property (nonatomic,assign) NSInteger question_is_required;
@property (nonatomic,strong) NSArray *answers;

@end
