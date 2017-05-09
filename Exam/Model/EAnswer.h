//
//  EAnswer.h
//  Exam
//
//  Created by gyq on 2017/2/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 answer
 */
@interface EAnswer : NSObject

@property (nonatomic,assign) NSInteger answer_id;
@property (nonatomic,assign) NSInteger question_id;
@property (nonatomic,copy) NSString *answer_content;
@property (nonatomic,assign) NSInteger answer_correct; // 是否为正确选项（多选题可能不止一个正确选项）
@property (nonatomic,assign) BOOL checked; // 该选项是否被选中

@end
