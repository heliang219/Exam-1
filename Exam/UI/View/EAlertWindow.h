//
//  EAlertWindow.h
//  Exam
//
//  Created by yongqingguo on 16/9/18.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EAlertWindow;

typedef NS_ENUM(NSUInteger,EAlertWindowStyle) {
    EAlertWindowStyleSystem, // 系统风格
    EAlertWindowStyleCustom, // 自定义风格
};

@protocol EAlertWindowDelegate <NSObject>

@optional

- (void)eAlertWindow:(EAlertWindow *)alertWindow didClickedAtIndex:(NSInteger)index;

@end

/**
 弹窗
 */
@interface EAlertWindow : UIWindow

@property (nonatomic,weak) id<EAlertWindowDelegate>delegate;
/**
 弹窗样式，有系统和自定义样式两种。如果选择了系统样式，则自定义无效
 */
@property (nonatomic,assign) EAlertWindowStyle style;
/**
 背景色
 */
@property (nonatomic,strong) UIColor *bgColor;
/**
 取消按钮背景色
 */
@property (nonatomic,strong) UIColor *cancelBtnBgColor;
/**
 确认按钮背景色
 */
@property (nonatomic,strong) UIColor *confirmBtnBgColor;
/**
 按钮内间距
 */
@property (nonatomic,assign) UIEdgeInsets btnInset;
/**
 确认按钮颜色
 */
@property (nonatomic,strong) UIColor *confirmBtnTitleColor;
/**
 文字字体
 */
@property (nonatomic,strong) UIFont *titleFont;
/**
 icon图标
 */
@property (nonatomic,strong) UIImage *icon;

+ (instancetype)sharedWindow;

- (void)show;

- (void)showWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle;

- (void)hide;

@end
