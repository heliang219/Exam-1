//
//  EExamPane.h
//  Exam
//
//  Created by yongqingguo on 2017/1/20.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EInstructionWindow.h"
#import "EQuestion.h"
@class CTCheckbox;
@class EAlertWindow;
@class ERightPane;

typedef NS_ENUM(NSInteger,ExamPaneType) {
    ExamPaneTypeExercise, // 模拟练习（文字缩放，上一题，下一题，交卷）
    ExamPaneTypeView, // 查看题目（上一题，下一题）
    ExamPaneTypeCheck, // 练习复卷（文字缩放，错题重考）
    ExamPaneTypeRetry, // 错题重考（文字缩放，上一题，下一题，交卷）
};

@protocol EExamPaneDelegate <NSObject>

@optional

- (void)backBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)instructionBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)scaleBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)previousBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)nextBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)commitBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)retryBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)numberBtnClickOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller section:(NSInteger)section row:(NSInteger)row;

@end

/**
 考试面板
 */
@interface EExamPane : UIControl

@property (nonatomic,weak) id<EExamPaneDelegate> delegate;

#pragma mark - topPane
@property (nonatomic,strong) UIView *topPane;
@property (nonatomic,strong) UILabel *titleLbl;  // 标题
@property (nonatomic,strong) UIButton *backBtn;  // 返回
@property (nonatomic,strong) UIButton *instructionBtn;  // 操作说明

#pragma mark - rightPane
@property (nonatomic,strong) ERightPane *rightPane;
@property (nonatomic,strong) UIButton *rightScrollBtn; // 右侧滑动按钮
@property (nonatomic,strong) UICollectionView *numberView;  // 题号视图

#pragma mark - exercisePane
@property (nonatomic,strong) UIView *exercisePane;
@property (nonatomic,strong) UIScrollView *scrollView;  // 可以滚动的容器
@property (nonatomic,strong) UILabel *kindLbl; // 问题类型
@property (nonatomic,strong) UILabel *questionLbl;  // 问题
@property (nonatomic,strong) CTCheckbox *checkbox1;  // 答案选项
@property (nonatomic,strong) CTCheckbox *checkbox2;
@property (nonatomic,strong) CTCheckbox *checkbox3;
@property (nonatomic,strong) CTCheckbox *checkbox4;

#pragma mark - bottomPane
@property (nonatomic,strong) UIView *bottomPane;
@property (nonatomic,strong) UILabel *remainTimeLbl;  // 剩余时间
@property (nonatomic,strong) UIButton *scaleBtn; // 文字缩放
@property (nonatomic,strong) UIButton *previousBtn;  // 上一题
@property (nonatomic,strong) UIButton *nextBtn;  // 下一题
@property (nonatomic,strong) UIButton *commitBtn;  // 交卷
@property (nonatomic,strong) UIButton *retryBtn; // 错题重考

#pragma mark - Window
@property (nonatomic,strong) EAlertWindow *alertWindow; // 弹窗
@property (nonatomic,strong) EInstructionWindow *instructionWindow;

@property (nonatomic,strong,readonly) EQuestion *currentQuestion;  // 当前试题

- (instancetype)initWithFrame:(CGRect)frame type:(ExamPaneType)type;

/**
 刷新checkbox实心圆点的颜色

 @param color 更新后的颜色
 */
- (void)refreshCheckboxHeartColor:(UIColor *)color;

/**
 刷新checkbox背景色
 
 @param color 更新后的背景色
 */
- (void)refreshCheckboxBackgroundColor:(UIColor *)color;

/**
 刷新标题

 @param title 要显示的标题
 */
- (void)refreshTitle:(NSString *)title;

/**
 刷新当前试题

 @param question 刷新后的当前试题
 @param lock     是否锁定答题面板
 */
- (void)refreshQuestion:(EQuestion *)question lock:(BOOL)lock;

/**
 刷新所有试题

 @param questions 刷洗后的所有试题
 */
- (void)refreshQuestions:(NSArray *)questions;

/**
 显示/隐藏右边栏

 @param show YES显示，NO隐藏
 */
- (void)showRightPane:(BOOL)show;

@end
