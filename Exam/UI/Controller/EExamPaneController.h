//
//  EExamPaneController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"
@class EQuestion;
@class EExamPane;

@protocol EExamPaneControllerDelegate <NSObject>

@optional

@required

- (void)backBtnClicked;
- (void)instructionBtnClicked;
- (void)previousBtnClicked;
- (void)nextBtnClicked;
- (void)commitBtnClicked;
- (void)numberBtnClickedAtSection:(NSInteger)section row:(NSInteger)row;

@end

/**
 答题面板（横屏）
 */
@interface EExamPaneController : EBaseController

@property (nonatomic,weak) id<EExamPaneControllerDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray *questions;  // 所有试题
@property (nonatomic,strong,readonly) EQuestion *currentQuestion;  // 当前试题

#pragma mark - 初始化方法

/**
 创建实例

 @param controller parent controller
 @param view parent view
 @paran title 显示在顶部的标题
 @param questions 要显示的questions
 @return 返回EExamPaneController对象
 */
+ (instancetype)createWithController:(UIViewController *)controller view:(UIView *)view delegate:(id<EExamPaneControllerDelegate>)delegate title:(NSString *)title questions:(NSArray *)questions;

#pragma mark - public methods

/**
 刷新标题

 @param title 标题
 */
- (void)refreshTitle:(NSString *)title;

/**
 刷新答题面板上的question

 @param question 刷新后的question
 */
- (void)refreshQuestion:(EQuestion *)question;

/**
 刷新右侧题号面板上的所有question

 @param questions 刷新后的所有question
 */
- (void)refreshQuestions:(NSArray *)questions;

/**
 上一题
 */
- (void)previousQuestion;

/**
 下一题
 */
- (void)nextQuestion;

/**
 提交
 */
- (void)commitExam;

@end
