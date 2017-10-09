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

- (ESubject *)queryTypeBySubId:(NSInteger)subject_id {
    ESubject *subject = [[ESubject alloc] init];
    if ([self.examDB open]) {
        NSString *sql = [NSString stringWithFormat:
                         @"SELECT * FROM %@ where subject_id = (SELECT subject_p_id FROM %@ where subject_id = '%@')",TB_SUBJECT,TB_SUBJECT,@(subject_id)];
        FMResultSet *rs = [self.examDB executeQuery:sql];
        while ([rs next]) {
            NSInteger subject_id = [rs intForColumn:@"subject_id"];
            NSInteger subject_p_id = [rs intForColumn:@"subject_p_id"];
            NSString *subject_title = [rs stringForColumn:@"subject_title"];
            
            subject.subject_id = subject_id;
            subject.subject_p_id = subject_p_id;
            subject.subject_title = subject_title;
        }
        [self.examDB close];
    }
    return subject;
}

- (ESubject *)querySubjectById:(NSInteger)subject_id {
    ESubject *subject = [[ESubject alloc] init];
    if ([self.examDB open]) {
        NSString *sql = [NSString stringWithFormat:
                         @"SELECT * FROM %@ where subject_id = '%@'",TB_SUBJECT,@(subject_id)];
        FMResultSet *rs = [self.examDB executeQuery:sql];
        while ([rs next]) {
            NSInteger subject_id = [rs intForColumn:@"subject_id"];
            NSInteger subject_p_id = [rs intForColumn:@"subject_p_id"];
            NSString *subject_title = [rs stringForColumn:@"subject_title"];
            
            subject.subject_id = subject_id;
            subject.subject_p_id = subject_p_id;
            subject.subject_title = subject_title;
        }
        [self.examDB close];
    }
    return subject;
}

- (BOOL)insertSubject:(ESubject *)subject {
    BOOL res = NO;
    NSArray *lists = [self queryAllTypes];
    // if the column exists,update it. else insert a new record
    for (int i = 0;i < lists.count;i ++) {
        ESubject *_subject = lists[i];
        if(_subject.subject_id == subject.subject_id) {
            return [self updateSubject:subject];
        }
        else continue;
    }
    if ([self.examDB open]) {
        NSInteger subject_id = subject.subject_id;
        NSInteger subject_p_id = subject.subject_p_id;
        NSString *subject_title = subject.subject_title;
        NSString *insertSql= [NSString stringWithFormat:
                              @"INSERT INTO '%@' ('subject_id','subject_p_id','subject_title') VALUES ('%@','%@','%@')",
                              TB_SUBJECT,@(subject_id),@(subject_p_id),subject_title];
        res = [self.examDB executeUpdate:insertSql];
        [self.examDB close];
    }
    return res;
}

- (BOOL)updateSubject:(ESubject *)subject {
    BOOL res = NO;
    if ([self.examDB open]) {
        NSInteger subject_id = subject.subject_id;
        NSInteger subject_p_id = subject.subject_p_id;
        NSString *subject_title = subject.subject_title;
        NSString *insertSql= [NSString stringWithFormat:
                              @"update '%@' set subject_p_id='%@',subject_title='%@' where subject_id='%@'",
                              TB_SUBJECT,@(subject_p_id),subject_title,@(subject_id)];
        res = [self.examDB executeUpdate:insertSql];
        [self.examDB close];
    }
    return res;
}

- (BOOL)deleteSubject:(ESubject *)subject {
    BOOL res = NO;
    if ([self.examDB open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               TB_SUBJECT, @"subject_id", @(subject.subject_id)];
        res = [self.examDB executeUpdate:deleteSql];
        [self.examDB close];
    }
    return res;
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

- (BOOL)insertQuestion:(EQuestion *)question {
    BOOL res = NO;
    NSArray *lists = [self queryQuestions:question.question_subject_id];
    // if the column exists,update it. else insert a new record
    for (int i = 0;i < lists.count;i ++) {
        EQuestion *_question = lists[i];
        if(_question.question_id == question.question_id) {
            return [self updateQuestion:question];
        }
        else continue;
    }
    if ([self.examDB open]) {
        NSInteger question_id = question.question_id;
        NSInteger question_subject_id = question.question_subject_id;
        NSString *question_content = question.question_content;
        NSString *question_type = question.question_type;
        NSInteger question_case_id = question.question_case_id;
        NSInteger question_is_required = question.question_is_required;
        NSString *insertSql= [NSString stringWithFormat:
                              @"INSERT INTO '%@' ('question_id','question_subject_id','question_content','question_type','question_case_id','question_is_required') VALUES ('%@','%@','%@','%@','%@','%@')",
                              TB_QUESTION,@(question_id),@(question_subject_id),question_content,question_type,@(question_case_id),@(question_is_required)];
        res = [self.examDB executeUpdate:insertSql];
        [self.examDB close];
    }
    return res;
}

- (BOOL)updateQuestion:(EQuestion *)question {
    BOOL res = NO;
    if ([self.examDB open]) {
        NSInteger question_id = question.question_id;
        NSInteger question_subject_id = question.question_subject_id;
        NSString *question_content = question.question_content;
        NSString *question_type = question.question_type;
        NSInteger question_case_id = question.question_case_id;
        NSInteger question_is_required = question.question_is_required;
        NSString *insertSql= [NSString stringWithFormat:
                              @"update '%@' set question_subject_id='%@',question_content='%@',question_type='%@',question_case_id='%@',question_is_required='%@' where question_id='%@'",
                              TB_QUESTION,@(question_subject_id),question_content,question_type,@(question_case_id),@(question_is_required),@(question_id)];
        res = [self.examDB executeUpdate:insertSql];
        [self.examDB close];
    }
    return res;
}

- (BOOL)deleteQuestion:(EQuestion *)question {
    BOOL res = NO;
    if ([self.examDB open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               TB_QUESTION, @"question_id", @(question.question_id)];
        res = [self.examDB executeUpdate:deleteSql];
        [self.examDB close];
    }
    return res;
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

- (BOOL)insertAnswer:(EAnswer *)answer {
    BOOL res = NO;
    NSArray *lists = [self queryAnswers:answer.question_id];
    // if the column exists,update it. else insert a new record
    for (int i = 0;i < lists.count;i ++) {
        EAnswer *_answer = lists[i];
        if(_answer.answer_id == answer.answer_id) {
            return [self updateAnswer:answer];
        }
        else continue;
    }
    if ([self.examDB open]) {
        NSInteger answer_id = answer.answer_id;
        NSInteger question_id = answer.question_id;
        NSString *answer_content = answer.answer_content;
        NSInteger answer_correct = answer.answer_correct;
        NSString *insertSql= [NSString stringWithFormat:
                              @"INSERT INTO '%@' ('answer_id','question_id','answer_content','answer_correct') VALUES ('%@','%@','%@','%@')",
                              TB_ANSWER,@(answer_id),@(question_id),answer_content,@(answer_correct)];
        res = [self.examDB executeUpdate:insertSql];
        [self.examDB close];
    }
    return res;
}

- (BOOL)updateAnswer:(EAnswer *)answer {
    BOOL res = NO;
    if ([self.examDB open]) {
        NSInteger answer_id = answer.answer_id;
        NSInteger question_id = answer.question_id;
        NSString *answer_content = answer.answer_content;
        NSInteger answer_correct = answer.answer_correct;
        NSString *insertSql= [NSString stringWithFormat:
                              @"update '%@' set answer_id='%@',question_id='%@',answer_content='%@',answer_correct='%@'",
                              TB_ANSWER,@(answer_id),@(question_id),answer_content,@(answer_correct)];
        res = [self.examDB executeUpdate:insertSql];
        [self.examDB close];
    }
    return res;
}

@end
