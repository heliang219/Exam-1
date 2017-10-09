//
//  EDBHelper.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
#import "ESubject.h"
#import "EQuestion.h"
#import "EAnswer.h"

/**
 本地数据库存取
 */
@interface EDBHelper : NSObject

@property (nonatomic,strong) FMDatabase *examDB;

+ (instancetype)defaultHelper;

#pragma mark - subjects

/**
 查询所有分类

 @return 返回包含ESubject对象的数组
 */
- (NSArray *)queryAllTypes;

/**
 根据subject_id查询所有子分类

 @param subject_id 要查询的subject_id
 @return 返回包含ESubject对象的数组
 */
- (NSArray *)querySubTypes:(NSInteger)subject_id;

- (ESubject *)queryTypeBySubId:(NSInteger)subject_id;

/**
 根据ID查询subject

 @param subject_id subject的ID
 @return 返回ESubject对象
 */
- (ESubject *)querySubjectById:(NSInteger)subject_id;

/**
 插入一条subject

 @param subject <#subject description#>
 */
- (BOOL)insertSubject:(ESubject *)subject;

/**
 更新一条subject

 @param subject <#subject description#>
 */
- (BOOL)updateSubject:(ESubject *)subject;

- (BOOL)deleteSubject:(ESubject *)subject;

#pragma mark - questions

/**
 根据subject_id查询所有question

 @param subject_id 要查询的subject_id
 @return 返回包含EQuestion对象的数组
 */
- (NSArray *)queryQuestions:(NSInteger)subject_id;

/**
 插入一条question

 @param question <#question description#>
 */
- (BOOL)insertQuestion:(EQuestion *)question;

/**
 更新一条question

 @param question <#question description#>
 */
- (BOOL)updateQuestion:(EQuestion *)question;

- (BOOL)deleteQuestion:(EQuestion *)question;

#pragma mark - answers

/**
 根据question_id查询所有的answer

 @param question_id 要查询的question_id
 @return 返回包含EAnswer对象的数组
 */
- (NSArray *)queryAnswers:(NSInteger)question_id;

- (BOOL)insertAnswer:(EAnswer *)answer;

- (BOOL)updateAnswer:(EAnswer *)answer;

@end
