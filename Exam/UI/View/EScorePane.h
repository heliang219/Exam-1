//
//  EScorePane.h
//  Exam
//
//  Created by yongqingguo on 2017/2/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EScorePane;

typedef NS_ENUM(NSInteger,ScorePaneType) {
    ScorePaneTypeExercise, // 模拟练习（模拟练习成绩分数，练习平均分，练习复卷）
    ScorePaneTypeCheck, // 练习复卷（本次练习成绩，练习平均分，练习最高分，练习次数，再次练习复卷）
};

@protocol EScorePaneDelegate <NSObject>

@optional

- (void)backBtnClickedOnPane:(UIView *)pane controller:(id<EScorePaneDelegate>)controller;
- (void)shareBtnClickedOnPane:(UIView *)pane controller:(id<EScorePaneDelegate>)controller;
- (void)helpBtnClickedOnPane:(UIView *)pane controller:(id<EScorePaneDelegate>)controller;
- (void)bottomBtnClickedOnPane:(UIView *)pane controller:(id<EScorePaneDelegate>)controller;

@end

/**
 成绩面板
 */
@interface EScorePane : UIControl

@property (nonatomic,weak) id<EScorePaneDelegate> delegate;

#pragma mark - top pane
@property (nonatomic,strong) UIView *topPane;
@property (nonatomic,strong) UIButton *backBtn; // 返回按钮
@property (nonatomic,strong) UIButton *shareBtn; // 分享
@property (nonatomic,strong) UIButton *helpBtn; // 帮助
@property (nonatomic,strong) UILabel *titleLbl; // 标题

#pragma mark - middle pane
@property (nonatomic,strong) UIView *middlePane;
@property (nonatomic,strong) UILabel *currentScoreTitleLbl; // 当前分数
@property (nonatomic,strong) UILabel *currentScoreLbl; // 当前分数
@property (nonatomic,strong) UILabel *separator; // 分割线
@property (nonatomic,strong) UILabel *averageScoreTitleLbl; // 平均分
@property (nonatomic,strong) UILabel *averageScoreLbl; // 平均分

#pragma mark - bottom pane
@property (nonatomic,strong) UIView *bottomPane;
@property (nonatomic,strong) UILabel *bottom_averageScoreLbl; // 练习平均分
@property (nonatomic,strong) UILabel *separator1; // 分割线
@property (nonatomic,strong) UILabel *bottom_maxScoreLbl; // 练习最高分
@property (nonatomic,strong) UILabel *separator2; // 分割线
@property (nonatomic,strong) UILabel *bottom_timesLbl; // 练习次数
@property (nonatomic,strong) UIButton *bottom_btn; // 底部按钮

- (instancetype)initWithFrame:(CGRect)frame type:(ScorePaneType)type;

- (void)refreshTitle:(NSString *)title;

- (void)refreshScore:(NSString *)score rate:(NSString *)rate;

@end
