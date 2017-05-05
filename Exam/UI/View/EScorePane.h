//
//  EScorePane.h
//  Exam
//
//  Created by yongqingguo on 2017/2/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EScorePane;

@protocol EScorePaneDelegate <NSObject>

@optional

- (void)backBtnClickedOnPane:(UIView *)pane controller:(id<EScorePaneDelegate>)controller;
- (void)correctBtnClickedOnPane:(UIView *)pane controller:(id<EScorePaneDelegate>)controller;

@end

/**
 得分面板
 */
@interface EScorePane : UIControl

@property (nonatomic,weak) id<EScorePaneDelegate> delegate;

@property (nonatomic,strong) UIView *topBar;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *topLbl;
@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UILabel *scoreLbl;
@property (nonatomic,strong) UILabel *rateLbl;
@property (nonatomic,strong) UIButton *correctBtn;

- (void)refreshScore:(NSString *)score rate:(NSString *)rate;

@end
