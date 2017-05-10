//
//  EExamPane.h
//  Exam
//
//  Created by yongqingguo on 2017/1/20.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTCheckbox;
@class EQuestion;
@class EAlertWindow;
#import "EInstructionWindow.h"

typedef NS_ENUM(NSInteger,ExamPaneType) {
    ExamPaneTypeBlank, // 模拟练习
    ExamPaneTypeFull, // 练习复卷/查看试题
};

@protocol EExamPaneDelegate <NSObject>

@optional

- (void)backBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)instructionBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)previousBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)nextBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
- (void)commitBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller;
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

#pragma mark - timerPane
@property (nonatomic,strong) UIView *timerPane;
@property (nonatomic,strong) UILabel *totalTimeLbl;  // 考试时间
@property (nonatomic,strong) UILabel *remainTimeLbl;  // 剩余时间

#pragma mark - rightPane
@property (nonatomic,strong) UIView *rightPane;
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
@property (nonatomic,strong) UIButton *previousBtn;  // 上一题
@property (nonatomic,strong) UIButton *nextBtn;  // 下一题
@property (nonatomic,strong) UIButton *commitBtn;  // 交卷

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

@end
