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

typedef NS_ENUM(NSInteger,ExamPaneType) {
    ExamPaneTypeBlank,
    ExamPaneTypeFull,
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

@property (nonatomic,strong,readonly) EQuestion *currentQuestion;  // 当前试题

- (instancetype)initWithFrame:(CGRect)frame type:(ExamPaneType)type;

- (void)refreshTitle:(NSString *)title;

/**
 刷新当前试题

 @param question 刷新后的当前试题
 */
- (void)refreshQuestion:(EQuestion *)question;

/**
 刷新所有试题

 @param questions 刷洗后的所有试题
 */
- (void)refreshQuestions:(NSArray *)questions;

@end
