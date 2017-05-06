//
//  EAlertWindow.m
//  Exam
//
//  Created by yongqingguo on 16/9/18.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "EAlertWindow.h"
#import "UILabel+Additions.h"

#define bgViewWidth 280.f
#define bgViewHeight 131.f
#define btnHeight 50.f
#define lineWidth 1.f

@implementation EAlertWindow
{
    UIView *_bgView;
    UIView *_contentView;
    UIView *_textView;
    UILabel *_titleLbl;
    UIButton *_cancelBtn;
    UIButton *_confirmBtn;
    
    EAlertWindowStyle _style;
    UIEdgeInsets _btnInset;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)sharedWindow {
    static EAlertWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        window = [[EAlertWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        window.userInteractionEnabled = YES;
    });
    return window;
}

- (void)setStyle:(EAlertWindowStyle)style {
    _style = style;
    [self setNeedsLayout];
}

- (void)setBgColor:(UIColor *)bgColor {
    if (_style == EAlertWindowStyleSystem) {
        return;
    }
    _contentView.backgroundColor = bgColor;
    _textView.backgroundColor = bgColor;
}

- (UIColor *)bgColor {
    return _textView.backgroundColor;
}

- (void)setCancelBtnBgColor:(UIColor *)cancelBtnBgColor {
    if (_style == EAlertWindowStyleSystem) {
        return;
    }
    _cancelBtn.backgroundColor = cancelBtnBgColor;
}

- (UIColor *)cancelBtnBgColor {
    return _cancelBtn.backgroundColor;
}

- (void)setConfirmBtnBgColor:(UIColor *)confirmBtnBgColor {
    if (_style == EAlertWindowStyleSystem) {
        return;
    }
    _confirmBtn.backgroundColor = confirmBtnBgColor;
}

- (UIColor *)confirmBtnBgColor {
    return _confirmBtn.backgroundColor;
}

- (void)setBtnInset:(UIEdgeInsets)btnInset {
    if (_style == EAlertWindowStyleSystem) {
        return;
    }
    _btnInset = btnInset;
    [self setNeedsLayout];
}

- (UIEdgeInsets)btnInset {
    return _btnInset;
}

- (void)setConfirmBtnTitleColor:(UIColor *)confirmBtnTitleColor {
    if (_style == EAlertWindowStyleSystem) {
        return;
    }
    [_confirmBtn setTitleColor:confirmBtnTitleColor forState:UIControlStateNormal];
}

- (UIColor *)confirmBtnTitleColor {
    return _confirmBtn.titleLabel.textColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleLbl.font = titleFont;
    [self setNeedsLayout];
}

- (UIFont *)titleFont {
    return _titleLbl.font;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _btnInset = UIEdgeInsetsZero;
        
        // bgview
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.7;
        [self addSubview:_bgView];
        
        // content view
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.alpha = 0.99;
        _contentView.layer.borderWidth = 0.5;
        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 12.f;
        [self addSubview:_contentView];
        
        _textView = [[UIView alloc] init];
        _textView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
        [_contentView addSubview:_textView];
        
        // title label
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.numberOfLines = 50;
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.text = @"提示";
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        [_textView addSubview:_titleLbl];
        
        // cancel button
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancelBtn];
        
        // confirm button
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_confirmBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    _bgView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    
    // 计算文本高度
    CGFloat textHeight = [UILabel getHeightByWidth:bgViewWidth - 20 title:_titleLbl.text font:_titleLbl.font] + 30;
    // 限制最小和最大高度（131~(屏幕高度-40)）
    CGFloat contentHeight = (textHeight + btnHeight) > bgViewHeight ? (textHeight + btnHeight) : bgViewHeight;
    contentHeight = (contentHeight < (bounds.size.height - 40) ? contentHeight : (bounds.size.height - 40));
    _contentView.frame = CGRectMake((bounds.size.width - bgViewWidth) / 2, (bounds.size.height - contentHeight) / 2, bgViewWidth, contentHeight);
    _textView.frame = CGRectMake(0, 0, bgViewWidth, contentHeight - lineWidth * 0.7 - btnHeight);
    _titleLbl.frame = CGRectMake(10, 0, bgViewWidth - 20, _textView.bounds.size.height);
    
    if (!_confirmBtn.hidden) {
        _cancelBtn.frame = CGRectMake(_btnInset.left, contentHeight - btnHeight + _btnInset.top, (bgViewWidth - lineWidth) / 2 - _btnInset.left - _btnInset.right, btnHeight - _btnInset.top - _btnInset.bottom);
    } else {
        _cancelBtn.frame = CGRectMake(_btnInset.left, contentHeight - btnHeight + _btnInset.top, bgViewWidth - _btnInset.left - _btnInset.right, btnHeight - _btnInset.top - _btnInset.bottom);
    }
    if (!_cancelBtn.hidden) {
        _confirmBtn.frame = CGRectMake(bgViewWidth / 2 + _btnInset.left, contentHeight - btnHeight + _btnInset.top, (bgViewWidth - lineWidth) / 2 - _btnInset.left - _btnInset.right, btnHeight - _btnInset.top - _btnInset.bottom);
    } else {
        _confirmBtn.frame = CGRectMake(_btnInset.left, contentHeight - btnHeight + _btnInset.top, bgViewWidth - _btnInset.left - _btnInset.right, btnHeight - _btnInset.top - _btnInset.bottom);
    }
}

#pragma mark - 按钮点击

- (void)cancelBtnClicked:(UIButton *)sender {
    if (!((UIViewController *)self.delegate).view.window) {
        return;
    }
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(eAlertWindow:didClickedAtIndex:)]) {
        [self.delegate eAlertWindow:self didClickedAtIndex:0];
    }
}

- (void)confirmBtnClicked:(UIButton *)sender {
    if (!((UIViewController *)self.delegate).view.window) {
        return;
    }
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(eAlertWindow:didClickedAtIndex:)]) {
        [self.delegate eAlertWindow:self didClickedAtIndex:1];
    }
}

#pragma mark - 显示与隐藏

- (void)show {
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (!strongSelf.superview) {
            [strongSelf makeKeyAndVisible];
        }
        strongSelf.hidden = NO;
    });
}

- (void)showWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle {
    if (title) {
        _titleLbl.text = title;
    }
    if (cancelTitle) {
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    } else {
        _cancelBtn.hidden = YES;
    }
    if (confirmTitle) {
        _confirmBtn.hidden = NO;
        [_confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
    } else {
        _confirmBtn.hidden = YES;
    }
    [self setNeedsLayout];
    [self show];
}

- (void)hide {
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (!strongSelf.superview) {
            [strongSelf resignKeyWindow];
        }
        strongSelf.hidden = YES;
    });
    // iOS10下hidden之后就变成竖屏了，需要手动恢复现场
}

@end
