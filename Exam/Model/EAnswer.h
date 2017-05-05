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
@property (nonatomic,assign) NSInteger answer_correct;
@property (nonatomic,assign) BOOL checked;

@end
