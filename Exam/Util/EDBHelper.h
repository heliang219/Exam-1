//
//  EDBHelper.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

/**
 本地数据库存取
 */
@interface EDBHelper : NSObject

@property (nonatomic,strong) FMDatabase *examDB;

+ (instancetype)defaultHelper;

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

/**
 根据subject_id查询所有question

 @param subject_id 要查询的subject_id
 @return 返回包含EQuestion对象的数组
 */
- (NSArray *)queryQuestions:(NSInteger)subject_id;

/**
 根据question_id查询所有的answer

 @param question_id 要查询的question_id
 @return 返回包含EAnswer对象的数组
 */
- (NSArray *)queryAnswers:(NSInteger)question_id;

@end
