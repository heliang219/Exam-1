//
//  EScorePane.m
//  Exam
//
//  Created by yongqingguo on 2017/2/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EScorePane.h"

@implementation EScorePane

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = kThemeColor;
        [self addSubview:_topBar];
        
        _topLbl = [[UILabel alloc] init];
        _topLbl.textAlignment = NSTextAlignmentCenter;
        _topLbl.font = kMediumFont;
        _topLbl.text = @"成绩";
        _topLbl.backgroundColor = [UIColor clearColor];
        _topLbl.userInteractionEnabled = YES;
        [_topBar addSubview:_topLbl];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = kSmallFont;
        _backBtn.backgroundColor = [UIColor orangeColor];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topLbl addSubview:_backBtn];
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.font = kBigFont;
        _titleLbl.backgroundColor = [UIColor darkGrayColor];
        _titleLbl.text = @"模拟练习成绩";
        _titleLbl.textColor = [UIColor whiteColor];
        [self addSubview:_titleLbl];
        
        _scoreLbl = [[UILabel alloc] init];
        _scoreLbl.textAlignment = NSTextAlignmentCenter;
        _scoreLbl.font = kBigFont;
        _scoreLbl.backgroundColor = [UIColor orangeColor];
        _scoreLbl.text = @"得分\n\n0分";
        _scoreLbl.numberOfLines = 3;
        _scoreLbl.textColor = [UIColor whiteColor];
        [self addSubview:_scoreLbl];
        
        _rateLbl = [[UILabel alloc] init];
        _rateLbl.textAlignment = NSTextAlignmentCenter;
        _rateLbl.font = kBigFont;
        _rateLbl.backgroundColor = [UIColor orangeColor];
        _rateLbl.text = @"通过率\n\n0%";
        _rateLbl.numberOfLines = 3;
        _rateLbl.textColor = [UIColor whiteColor];
        [self addSubview:_rateLbl];
        
        _correctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_correctBtn setTitle:@"练习复卷" forState:UIControlStateNormal];
        [_correctBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _correctBtn.titleLabel.font = kMediumFont;
        _correctBtn.backgroundColor = [UIColor cyanColor];
        [_correctBtn addTarget:self action:@selector(correctBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_correctBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    _topBar.frame = CGRectMake(0, 0, bounds.size.width, kNavigationBarHeight);
    
    _backBtn.frame = CGRectMake(kEPadding, 7, 100, 30);
    
    _topLbl.frame = CGRectMake(0, 20, bounds.size.width, _topBar.bounds.size.height - 20);
    
    _titleLbl.frame = CGRectMake(kEPadding, _topBar.bounds.size.height + kEPadding, bounds.size.width - kEPadding * 2, 40.f);
    
    _scoreLbl.frame = CGRectMake(kEPadding, _titleLbl.frame.origin.y + _titleLbl.bounds.size.height + kEPadding, (bounds.size.width - kEPadding * 3) * 0.382, bounds.size.height - kEPadding * 4 - _topBar.bounds.size.height - _titleLbl.bounds.size.height - 40.f);
    
    _rateLbl.frame = CGRectMake(kEPadding * 2 + _scoreLbl.bounds.size.width, _scoreLbl.frame.origin.y, (bounds.size.width - kEPadding * 3) * 0.618, _scoreLbl.bounds.size.height);
    
    _correctBtn.frame = CGRectMake(_rateLbl.frame.origin.x, bounds.size.height - 40.f - kEPadding, _rateLbl.bounds.size.width, 40.f);
}

- (void)refreshScore:(NSString *)score rate:(NSString *)rate {
    NSString *scoreStr = [NSString stringWithFormat:@"得分\n\n%@",score];
    // 创建NSMutableAttributedString
    NSMutableAttributedString *scoreAttrStr = [[NSMutableAttributedString alloc] initWithString:scoreStr];
    // 设置字体和设置字体的范围
    [scoreAttrStr addAttribute:NSFontAttributeName value:kMediumFont range:NSMakeRange(0, 4)];
    [scoreAttrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:40.f] range:NSMakeRange(4, scoreStr.length - 4)];
    _scoreLbl.attributedText = scoreAttrStr;
    
    NSString *rateStr = [NSString stringWithFormat:@"通过率\n\n%@",rate];
    // 创建NSMutableAttributedString
    NSMutableAttributedString *rateAttrStr = [[NSMutableAttributedString alloc] initWithString:rateStr];
    // 设置字体和设置字体的范围
    [rateAttrStr addAttribute:NSFontAttributeName value:kMediumFont range:NSMakeRange(0, 5)];
    [rateAttrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:40.f] range:NSMakeRange(5, rateStr.length - 5)];
    _rateLbl.attributedText = rateAttrStr;
}

#pragma mark - Button Action

- (void)backBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClickedOnPane:controller:)]) {
        [self.delegate backBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)correctBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(correctBtnClickedOnPane:controller:)]) {
        [self.delegate correctBtnClickedOnPane:self controller:self.delegate];
    }
}

@end
