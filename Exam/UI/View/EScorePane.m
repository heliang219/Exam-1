//
//  EScorePane.m
//  Exam
//
//  Created by yongqingguo on 2017/2/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EScorePane.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UILabel+Additions.h"

#define middleLblWidth 200.f

@implementation EScorePane
{
    ScorePaneType _type;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame type:(ScorePaneType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self initTopPane];
        [self initMiddlePane];
        [self initBottomPane];
        switch (_type) {
            case ScorePaneTypeExercise:
            {
                _bottomPane.backgroundColor = [UIColor whiteColor];
                _currentScoreTitleLbl.text = @"模拟练习成绩分数";
                [_bottom_btn setTitle:@"练习复卷" forState:UIControlStateNormal];
            }
                break;
            case ScorePaneTypeCheck:
            {
                _bottomPane.backgroundColor = RGBCOLOR(249, 248, 248);
                _bottomPane.layer.borderColor = HEXCOLOR(0xdfe3e9).CGColor;
                _bottomPane.layer.borderWidth = 0.8;
                _currentScoreTitleLbl.text = @"本次练习成绩";
                [_bottom_btn setTitle:@"再次练习复卷" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)initTopPane {
    _topPane = [[UIView alloc] init];
    _topPane.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topPane];
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.font = kMediumFont;
    _titleLbl.text = @"模拟练习成绩";
    _titleLbl.backgroundColor = [UIColor clearColor];
    _titleLbl.userInteractionEnabled = YES;
    [_topPane addSubview:_titleLbl];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:IMAGE_BY_NAMED(@"back") forState:UIControlStateNormal];
    [_backBtn setImage:IMAGE_BY_NAMED(@"back") forState:UIControlStateHighlighted];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn setEnlargeEdgeWithTop:10 right:50 bottom:10 left:10];
    [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPane addSubview:_backBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setTitleColor:RGBCOLOR(57, 138, 228) forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = kSmallFont;
    _shareBtn.backgroundColor = [UIColor clearColor];
    [_shareBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPane addSubview:_shareBtn];
    
    _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_helpBtn setTitle:@"帮助" forState:UIControlStateNormal];
    [_helpBtn setTitleColor:RGBCOLOR(57, 138, 228) forState:UIControlStateNormal];
    _helpBtn.titleLabel.font = kSmallFont;
    _helpBtn.backgroundColor = [UIColor clearColor];
    [_helpBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_helpBtn addTarget:self action:@selector(helpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPane addSubview:_helpBtn];
}

- (void)initMiddlePane {
    _middlePane = [[UIView alloc] init];
    _middlePane.backgroundColor = [UIColor whiteColor];
    [self addSubview:_middlePane];
    
    _currentScoreTitleLbl = [[UILabel alloc] init];
    _currentScoreTitleLbl.textAlignment = NSTextAlignmentCenter;
    _currentScoreTitleLbl.font = kMediumFont;
    _currentScoreTitleLbl.backgroundColor = [UIColor clearColor];
    _currentScoreTitleLbl.text = @"模拟练习成绩分数";
    _currentScoreTitleLbl.textColor = [UIColor blackColor];
    [_middlePane addSubview:_currentScoreTitleLbl];
    
    _currentScoreLbl = [[UILabel alloc] init];
    _currentScoreLbl.textAlignment = NSTextAlignmentCenter;
    _currentScoreLbl.font = [UIFont systemFontOfSize:50.f];
    _currentScoreLbl.backgroundColor = [UIColor clearColor];
    _currentScoreLbl.text = @"100分";
    _currentScoreLbl.textColor = kThemeColor;
    [_middlePane addSubview:_currentScoreLbl];
    
    _separator = [[UILabel alloc] init];
    _separator.backgroundColor = HEXCOLOR(0xdfe3e9);
    [_middlePane addSubview:_separator];
    
    _averageScoreTitleLbl = [[UILabel alloc] init];
    _averageScoreTitleLbl.textAlignment = NSTextAlignmentCenter;
    _averageScoreTitleLbl.font = kMediumFont;
    _averageScoreTitleLbl.backgroundColor = [UIColor clearColor];
    _averageScoreTitleLbl.text = @"练习平均分";
    _averageScoreTitleLbl.textColor = [UIColor blackColor];
    [_middlePane addSubview:_averageScoreTitleLbl];
    
    _averageScoreLbl = [[UILabel alloc] init];
    _averageScoreLbl.textAlignment = NSTextAlignmentCenter;
    _averageScoreLbl.font = [UIFont systemFontOfSize:50.f];
    _averageScoreLbl.backgroundColor = [UIColor clearColor];
    _averageScoreLbl.text = @"60分";
    _averageScoreLbl.textColor = kThemeColor;
    [_middlePane addSubview:_averageScoreLbl];
}

- (void)initBottomPane {
    _bottomPane = [[UIView alloc] init];
    _bottomPane.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomPane];
    
    _bottom_averageScoreLbl = [[UILabel alloc] init];
    _bottom_averageScoreLbl.textAlignment = NSTextAlignmentLeft;
    _bottom_averageScoreLbl.font = kMediumFont;
    _bottom_averageScoreLbl.backgroundColor = [UIColor clearColor];
    _bottom_averageScoreLbl.text = @"练习平均分\n75分";
    _bottom_averageScoreLbl.numberOfLines = 2;
    _bottom_averageScoreLbl.textColor = [UIColor blackColor];
    [_bottomPane addSubview:_bottom_averageScoreLbl];
    
    _separator1 = [[UILabel alloc] init];
    _separator1.backgroundColor = HEXCOLOR(0xdfe3e9);
    [_bottomPane addSubview:_separator1];
    
    _bottom_maxScoreLbl = [[UILabel alloc] init];
    _bottom_maxScoreLbl.textAlignment = NSTextAlignmentLeft;
    _bottom_maxScoreLbl.font = kMediumFont;
    _bottom_maxScoreLbl.backgroundColor = [UIColor clearColor];
    _bottom_maxScoreLbl.text = @"练习最高分\n75分";
    _bottom_maxScoreLbl.numberOfLines = 2;
    _bottom_maxScoreLbl.textColor = [UIColor blackColor];
    [_bottomPane addSubview:_bottom_maxScoreLbl];
    
    _separator2 = [[UILabel alloc] init];
    _separator2.backgroundColor = HEXCOLOR(0xdfe3e9);
    [_bottomPane addSubview:_separator2];
    
    _bottom_timesLbl = [[UILabel alloc] init];
    _bottom_timesLbl.textAlignment = NSTextAlignmentLeft;
    _bottom_timesLbl.font = kMediumFont;
    _bottom_timesLbl.backgroundColor = [UIColor clearColor];
    _bottom_timesLbl.text = @"练习次数\n3次";
    _bottom_timesLbl.numberOfLines = 2;
    _bottom_timesLbl.textColor = [UIColor blackColor];
    [_bottomPane addSubview:_bottom_timesLbl];
    
    _bottom_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottom_btn setTitle:@"练习复卷" forState:UIControlStateNormal];
    [_bottom_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _bottom_btn.titleLabel.font = kMediumFont;
    _bottom_btn.backgroundColor = [UIColor clearColor];
    _bottom_btn.layer.borderColor = kThemeColor.CGColor;
    _bottom_btn.layer.borderWidth = 1.f;
    _bottom_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_bottom_btn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPane addSubview:_bottom_btn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    CGFloat bottomPaneHeight = 104.f * bounds.size.height / 375.f;
    CGFloat bottomBtnWidth = 124.f * bounds.size.width / 667.f;
    CGFloat bottomBtnHeight = 44.f * bounds.size.height / 375.f;
    CGFloat bottomBtnRightMargin = 15.f * bounds.size.width / 667.f;
    
#pragma mark - top pane
    _topPane.frame = CGRectMake(0, 0, bounds.size.width, kNavigationBarHeight);
    _backBtn.frame = CGRectMake(kEPadding, (kNavigationBarHeight - 20.f - 24.f) / 2.f + 20.f, 24, 24);
    _titleLbl.frame = CGRectMake(0, 20, bounds.size.width, _topPane.bounds.size.height - 20);
    
#pragma mark - middle pane
    _middlePane.frame = CGRectMake(0, _topPane.bounds.size.height, bounds.size.width, bounds.size.height - _topPane.bounds.size.height - bottomPaneHeight);
    switch (_type) {
        case ScorePaneTypeExercise:
        {
            _currentScoreTitleLbl.frame = CGRectMake((bounds.size.width / 2.f - middleLblWidth) / 2.f, kEPadding * 4, middleLblWidth, 20);
            CGFloat scoreLblWidth = [UILabel getWidthWithTitle:_currentScoreLbl.text font:_currentScoreLbl.font];
            CGFloat scoreLblHeight = [UILabel getHeightByWidth:scoreLblWidth title:_currentScoreLbl.text font:_currentScoreLbl.font] - 20.f;
            _currentScoreLbl.frame = CGRectMake((bounds.size.width / 2.f - scoreLblWidth) / 2.f, _middlePane.bounds.size.height - kEPadding * 4 - scoreLblHeight, scoreLblWidth, scoreLblHeight);
            _separator.frame = CGRectMake(bounds.size.width / 2.f, _currentScoreTitleLbl.frame.origin.y, 1.f, _currentScoreLbl.frame.origin.y + scoreLblHeight - _currentScoreTitleLbl.frame.origin.y);
            _averageScoreTitleLbl.frame = CGRectMake((bounds.size.width / 2.f - middleLblWidth) / 2.f + bounds.size.width / 2.f, _currentScoreTitleLbl.frame.origin.y, middleLblWidth, 20);
            CGFloat averageScoreLblWidth = [UILabel getWidthWithTitle:_averageScoreLbl.text font:_averageScoreLbl.font];
            CGFloat averageScoreLblHeight = [UILabel getHeightByWidth:averageScoreLblWidth title:_averageScoreLbl.text font:_averageScoreLbl.font] - 20.f;
            _averageScoreLbl.frame = CGRectMake((bounds.size.width / 2.f - averageScoreLblWidth) / 2.f + bounds.size.width / 2.f, _currentScoreLbl.frame.origin.y, averageScoreLblWidth, averageScoreLblHeight);
        }
            break;
        case ScorePaneTypeCheck:
        {
            _currentScoreTitleLbl.frame = CGRectMake(40.f * kFrameWidth / 667.f, (_middlePane.bounds.size.height - 20.f) / 2.f, middleLblWidth, 20);
            _currentScoreTitleLbl.textAlignment = NSTextAlignmentLeft;
            _currentScoreLbl.frame = CGRectMake((bounds.size.width - middleLblWidth) / 2.f, (_middlePane.bounds.size.height - 100) / 2.f, middleLblWidth, 100.f);
            _averageScoreTitleLbl.hidden = YES;
            _averageScoreLbl.hidden = YES;
        }
            break;
        default:
            break;
    }
    
#pragma mark - bottom pane
    _bottomPane.frame = CGRectMake(0, bounds.size.height - bottomPaneHeight, bounds.size.width, bottomPaneHeight);
    switch (_type) {
        case ScorePaneTypeExercise:
        {
            _bottom_averageScoreLbl.hidden = YES;
            _bottom_maxScoreLbl.hidden = YES;
            _bottom_timesLbl.hidden = YES;
            _separator1.hidden = YES;
            _separator2.hidden = YES;
        }
            break;
        case ScorePaneTypeCheck:
        {
            _bottom_averageScoreLbl.hidden = NO;
            _bottom_maxScoreLbl.hidden = NO;
            _bottom_timesLbl.hidden = NO;
            _separator1.hidden = NO;
            _separator2.hidden = NO;
            CGFloat lblTopMargin = 20.f * kFrameHeight / 375.f;
            CGFloat lblLeftMargin = 40.f * kFrameWidth / 667.f;
            CGFloat lblHeight = 64.f * kFrameHeight / 375.f;
            CGFloat lbl1Width = [UILabel getWidthWithTitle:_bottom_averageScoreLbl.text font:_bottom_averageScoreLbl.font];
            _bottom_averageScoreLbl.frame = CGRectMake(lblLeftMargin, lblTopMargin, lbl1Width, lblHeight);
            CGFloat lbl2Width = [UILabel getWidthWithTitle:_bottom_maxScoreLbl.text font:_bottom_maxScoreLbl.font];
            _bottom_maxScoreLbl.frame = CGRectMake(_bottom_averageScoreLbl.frame.origin.x + lbl1Width + lblLeftMargin * 2, lblTopMargin, lbl2Width, lblHeight);
            CGFloat lbl3Width = [UILabel getWidthWithTitle:_bottom_timesLbl.text font:_bottom_timesLbl.font];
            _bottom_timesLbl.frame = CGRectMake(_bottom_maxScoreLbl.frame.origin.x + lbl2Width + lblLeftMargin * 2, lblTopMargin, lbl3Width, lblHeight);
            _separator1.frame = CGRectMake(_bottom_averageScoreLbl.frame.origin.x + lbl1Width + lblLeftMargin, lblTopMargin, 1.f, lblHeight);
            _separator2.frame = CGRectMake(_bottom_maxScoreLbl.frame.origin.x + lbl2Width + lblLeftMargin, lblTopMargin, 1.f, lblHeight);
        }
            break;
        default:
            break;
    }
    _bottom_btn.frame = CGRectMake(bounds.size.width - bottomBtnWidth - bottomBtnRightMargin, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
    _bottom_btn.layer.cornerRadius = bottomBtnHeight / 2.2;
    _bottom_btn.layer.masksToBounds = YES;
}

#pragma mark - public methods

- (void)refreshTitle:(NSString *)title {
    if (title) {
        _titleLbl.text = title;
        [_titleLbl setNeedsDisplay];
    }
}

- (void)refreshScore:(NSString *)score average:(NSString *)average {
    NSString *scoreStr = score;
    // 创建NSMutableAttributedString
    NSMutableAttributedString *scoreAttrStr = [[NSMutableAttributedString alloc] initWithString:scoreStr];
    // 设置字体和设置字体的范围
    [scoreAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50.f] range:NSMakeRange(0, scoreStr.length - 1)];
    [scoreAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.f] range:NSMakeRange(scoreStr.length - 1, 1)];
    [scoreAttrStr addAttribute:NSForegroundColorAttributeName value:kThemeColor range:NSMakeRange(0, scoreStr.length)];
    _currentScoreLbl.attributedText = scoreAttrStr;
    
    NSString *averageStr = average;
    // 创建NSMutableAttributedString
    NSMutableAttributedString *averageAttrStr = [[NSMutableAttributedString alloc] initWithString:averageStr];
    // 设置字体和设置字体的范围
    [averageAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50.f] range:NSMakeRange(0, averageStr.length - 1)];
    [averageAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.f] range:NSMakeRange(averageStr.length - 1, 1)];
    [averageAttrStr addAttribute:NSForegroundColorAttributeName value:kThemeColor range:NSMakeRange(0, averageStr.length)];
    _averageScoreLbl.attributedText = averageAttrStr;
}

#pragma mark - Button Action

- (void)backBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClickedOnPane:controller:)]) {
        [self.delegate backBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)shareBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareBtnClickedOnPane:controller:)]) {
        [self.delegate shareBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)helpBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(helpBtnClickedOnPane:controller:)]) {
        [self.delegate helpBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)bottomBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomBtnClickedOnPane:controller:)]) {
        [self.delegate bottomBtnClickedOnPane:self controller:self.delegate];
    }
}

@end
