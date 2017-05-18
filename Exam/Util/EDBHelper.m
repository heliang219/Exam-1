//
//  EDBHelper.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EDBHelper.h"
#import "FMDB.h"
#import "ESubject.h"
#import "EQuestion.h"
#import "EAnswer.h"

#define TB_SUBJECT @"exam_subject"
#define TB_QUESTION @"exam_question"
#define TB_RESULT @"exam_result"
#define TB_ANSWER @"exam_answer"

@interface EDBHelper()

@end

@implementation EDBHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths objectAtIndex:0];
        // 往应用程序路径中添加数据库文件名称，把它们拼接起来
        NSString *dbFilePath = [path stringByAppendingPathComponent:@"exam.db"];
        _examDB = [FMDatabase databaseWithPath:dbFilePath];
    }
    return self;
}

+ (instancetype)defaultHelper {
    static EDBHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[EDBHelper alloc] init];
    });
    return helper;
}

- (NSArray *)queryAllTypes {
    NSMutableArray *subjects = [NSMutableArray array];
    if ([self.examDB open]) {
        NSString *sql = [NSString stringWithFormat:
                         @"SELECT * FROM %@ where subject_p_id = 0",TB_SUBJECT];
        FMResultSet *rs = [self.examDB executeQuery:sql];
        while ([rs next]) {
            NSInteger subject_id = [rs intForColumn:@"subject_id"];
            NSInteger subject_p_id = [rs intForColumn:@"subject_p_id"];
            NSString *subject_title = [rs stringForColumn:@"subject_title"];
            ESubject *subject = [[ESubject alloc] init];
            subject.subject_id = subject_id;
            subject.subject_p_id = subject_p_id;
            subject.subject_title = subject_title;
            [subjects addObject:subject];
        }
        [self.examDB close];
    }
    return subjects;
}

- (NSArray *)querySubTypes:(NSInteger)subject_id {
    NSMutableArray *subjects = [NSMutableArray array];
    if ([self.examDB open]) {
        NSString *sql = [NSString stringWithFormat:
                         @"SELECT * FROM %@ where subject_p_id = '%@'",TB_SUBJECT,@(subject_id)];
        FMResultSet *rs = [self.examDB executeQuery:sql];
        while ([rs next]) {
            NSInteger subject_id = [rs intForColumn:@"subject_id"];
            NSInteger subject_p_id = [rs intForColumn:@"subject_p_id"];
            NSString *subject_title = [rs stringForColumn:@"subject_title"];
            ESubject *subject = [[ESubject alloc] init];
            subject.subject_id = subject_id;
            subject.subject_p_id = subject_p_id;
            subject.subject_title = subject_title;
            [subjects addObject:subject];
        }
        [self.examDB close];
    }
    return subjects;
}

- (NSArray *)queryQuestions:(NSInteger)subject_id {
    NSMutableArray *questions = [NSMutableArray array];
    if ([self.examDB open]) {
        NSString *sql = [NSString stringWithFormat:
                         @"SELECT * FROM %@ where question_subject_id = '%@' and question_case_id = (select min(question_case_id) from %@ where question_subject_id = '%@')",TB_QUESTION,@(subject_id),TB_QUESTION,@(subject_id)];
        FMResultSet *rs = [self.examDB executeQuery:sql];
        NSInteger index = 0;
        while ([rs next]) {
            NSInteger question_id = [rs intForColumn:@"question_id"];
            NSInteger question_subject_id = [rs intForColumn:@"question_subject_id"];
            NSString *question_content = [rs stringForColumn:@"question_content"];
            NSString *question_type = [rs stringForColumn:@"question_type"];
            NSInteger question_case_id = [rs intForColumn:@"question_case_id"];
            NSInteger question_is_required = [rs intForColumn:@"question_is_required"];
            EQuestion *question = [[EQuestion alloc] init];
            question.question_index = index;
            question.question_id = question_id;
            question.question_subject_id = question_subject_id;
            question.question_content = question_content;
            question.question_type = question_type;
            question.question_case_id = question_case_id;
            question.question_is_required = question_is_required;
            [questions addObject:question];
            index ++;
        }
        [self.examDB close];
    }
    return questions;
}

- (NSArray *)queryAnswers:(NSInteger)question_id {
    NSMutableArray *answers = [NSMutableArray array];
    if ([self.examDB open]) {
        NSString *sql = [NSString stringWithFormat:
                         @"SELECT * FROM %@ where question_id = '%@'",TB_ANSWER,@(question_id)];
        FMResultSet *rs = [self.examDB executeQuery:sql];
        while ([rs next]) {
            NSInteger answer_id = [rs intForColumn:@"answer_id"];
            NSInteger question_id = [rs intForColumn:@"question_id"];
            NSString *answer_content = [rs stringForColumn:@"answer_content"];
            NSInteger answer_correct = [rs intForColumn:@"answer_correct"];
            EAnswer *answer = [[EAnswer alloc] init];
            answer.answer_id = answer_id;
            answer.question_id = question_id;
            answer.answer_content = answer_content;
            answer.answer_correct = answer_correct;
            [answers addObject:answer];
        }
        [self.examDB close];
    }
    return answers;
}

@end
