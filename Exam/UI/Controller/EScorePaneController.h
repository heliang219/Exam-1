//
//  EScorePaneController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"

@protocol EScorePaneControllerDelegate <NSObject>

@required

- (void)backBtnClicked;
- (void)correctBtnClicked;

@end

/**
 成绩面板
 */
@interface EScorePaneController : EBaseController

@property (nonatomic,weak) id<EScorePaneControllerDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray *questions;  // 所有试题

+ (instancetype)createWithController:(UIViewController *)controller view:(UIView *)view delegate:(id<EScorePaneControllerDelegate>)delegate questions:(NSArray *)questions;

- (void)refreshScore:(NSString *)score rate:(NSString *)rate;

@end
