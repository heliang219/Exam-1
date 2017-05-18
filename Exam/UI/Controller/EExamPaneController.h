//
//  EExamPaneController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"
@class EQuestion;
#import "EExamPane.h"

/**
 手势方向

 - EGestureDirectionUnknown: 未知
 - EGestureDirectionAxisX: 水平方向
 - EGestureDirectionAxisY: 垂直方向
 */
typedef NS_ENUM(NSUInteger,EGestureDirection) {
    EGestureDirectionUnknown = -1,
    EGestureDirectionAxisX = 0,
    EGestureDirectionAxisY = 1,
    
};

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
@property (nonatomic,assign) UIInterfaceOrientation orientationWanted; // 期望返回到的页面的方向
@property (nonatomic,assign) ExamPaneType type; // 面板类型

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
 @param lock     是否锁定答题面板
 */
- (void)refreshQuestion:(EQuestion *)question lock:(BOOL)lock;

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

/**
 操作指示
 */
- (void)showInstructions;

@end
