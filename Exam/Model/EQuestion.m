//
//  EQuestion.m
//  Exam
//
//  Created by gyq on 2017/2/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EQuestion.h"
#import "EAnswer.h"
#import "EDBHelper.h"

@interface EQuestion()
{
    NSMutableArray *_answers;
}

@end

@implementation EQuestion

- (NSString *)question_type {
    if ([_question_type isEqualToString:@"judge"]) {
        return @"判断题";
    } else if ([_question_type isEqualToString:@"single_choice"]) {
        return @"单选题";
    } else if ([_question_type isEqualToString:@"multiple_choice"]) {
        return @"多选题";
    } else {
        return @"";
    }
}

- (NSArray *)answers {
    if (!_answers) {
        _answers = [NSMutableArray array];
        [_answers addObjectsFromArray:[[EDBHelper defaultHelper] queryAnswers:_question_id]];
    }
    return _answers;
}

@end
