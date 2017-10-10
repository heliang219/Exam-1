//
//  EExam.h
//  Exam
//
//  Created by yongqingguo on 2017/10/9.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EExam : NSObject

@property (nonatomic,assign) NSInteger exam_result_id;
@property (nonatomic,assign) NSInteger is_pass;
@property (nonatomic,assign) NSInteger score;
@property (nonatomic,assign) NSInteger correctCount;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;

@end
