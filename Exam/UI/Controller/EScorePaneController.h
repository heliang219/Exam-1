//
//  EScorePaneController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"
#import "EScorePane.h"

@protocol EScorePaneControllerDelegate <NSObject>

@required

- (void)backBtnClicked;
- (void)bottomBtnClicked;

@end

/**
 成绩面板
 */
@interface EScorePaneController : EBaseController

@property (nonatomic,weak) id<EScorePaneControllerDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray *questions;  // 所有试题
@property (nonatomic,assign) UIInterfaceOrientation orientationWanted; // 期望返回到的页面的方向

#pragma mark - 初始化方法

+ (instancetype)createWithController:(UIViewController *)controller view:(UIView *)view delegate:(id<EScorePaneControllerDelegate>)delegate title:(NSString *)title questions:(NSArray *)questions;

#pragma mark - public methods

/**
 刷新标题
 
 @param title 标题
 */
- (void)refreshTitle:(NSString *)title;

- (void)refreshScore:(NSString *)score rate:(NSString *)rate;

@end
