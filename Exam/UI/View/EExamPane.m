//
//  EExamPane.m
//  Exam
//
//  Created by yongqingguo on 2017/1/20.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EExamPane.h"
#import "EBlockCell.h"
#import "UIImage+Additions.h"
#import "CTCheckbox.h"
#import "EAnswer.h"
#import "UILabel+Additions.h"
#import "EAlertWindow.h"
#import "ERightPane.h"
#import "UIButton+EnlargeTouchArea.h"

#define topPaneHeight 64.f
#define topLblWidth 120.f
#define topBtnWidth 24.f
#define topBtnHeight 24.f
#define bottomBtnWidth 84.f
#define bottomBtnHeight 30.f
#define timerPaneHeight 44.f
#define bottomPaneHeight 50.f
#define rightScrollBtnWidth 25.f
#define rightScrollBtnHeight 70.f

#define numberOfCols 10

@interface EExamPane()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ERightPaneDelegate>
{
    ExamPaneType _type;
    UIColor *_checkboxSelectedBgColor;
    BOOL _rightPaneDidPan;
    BOOL _isRightPaneShowing;
}

@property (nonatomic,strong,readwrite) EQuestion *currentQuestion;  // 当前试题
@property (nonatomic,strong) NSArray *questions;  // 所有试题

@end

@implementation EExamPane

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame type:(ExamPaneType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _questions = [NSMutableArray array];
        [self initTopPane];
        [self initExercisePane];
        [self initBottomPane];
        [self initRightPane];
        [self initAlertWindow];
        [self initInstructionWindow];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRightNumber)];
        [_topPane addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRightNumber)];
        [_bottomPane addGestureRecognizer:tap2];
    }
    return self;
}

#pragma mark - Button Action

- (void)backBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClickedOnPane:controller:)]) {
        [self.delegate backBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)instructionBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(instructionBtnClickedOnPane:controller:)]) {
        [self.delegate instructionBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)scaleBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scaleBtnClickedOnPane:controller:)]) {
        [self.delegate scaleBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)previousBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(previousBtnClickedOnPane:controller:)]) {
        [self.delegate previousBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)nextBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextBtnClickedOnPane:controller:)]) {
        [self.delegate nextBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)commitBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitBtnClickedOnPane:controller:)]) {
        [self.delegate commitBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)retryBtnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(retryBtnClickedOnPane:controller:)]) {
        [self.delegate retryBtnClickedOnPane:self controller:self.delegate];
    }
}

- (void)numberActionAtSection:(NSInteger)section row:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberBtnClickOnPane:controller:section:row:)]) {
        [self.delegate numberBtnClickOnPane:self controller:self.delegate section:section row:row];
    }
}

#pragma mark - other methods

- (NSInteger)getQuestionTotalCount {
    return _questions.count;
}

- (void)checkboxDidChange:(CTCheckbox *)checkbox {
    ((EAnswer *)_currentQuestion.answers[checkbox.tag - 1000]).checked = checkbox.checked;
    if (checkbox.checked) {
         [checkbox setBackgroundColor:_checkboxSelectedBgColor forControlState:UIControlStateNormal];
    } else {
         [checkbox setBackgroundColor:RGBCOLOR(222, 224, 220) forControlState:UIControlStateNormal];
    }
    if (([_currentQuestion.question_type isEqualToString:@"判断题"] || [_currentQuestion.question_type isEqualToString:@"单选题"]) && checkbox.checked) {
        // 其它checkbox取消选中
        for (int i = 0; i < _currentQuestion.answers.count; i ++) {
            CTCheckbox *cb = (CTCheckbox *)[_scrollView viewWithTag:1000 + i];
            if (checkbox.tag - 1000 != i) {
                cb.checked = NO;
            }
        }
    }
    [_currentQuestion refreshAnswerType];
    [_numberView reloadData];
}

#pragma mark - init

/**
 初始化顶部面板
 */
- (void)initTopPane {
    _topPane = [[UIView alloc] init];
    _topPane.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topPane];
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.backgroundColor = [UIColor clearColor];
    _titleLbl.font = kMediumFont;
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.userInteractionEnabled = YES;
    [_topPane addSubview:_titleLbl];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:IMAGE_BY_NAMED(@"back") forState:UIControlStateNormal];
    [_backBtn setImage:IMAGE_BY_NAMED(@"back") forState:UIControlStateHighlighted];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn setEnlargeEdgeWithTop:10 right:50 bottom:10 left:10];
    [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPane addSubview:_backBtn];
    
    _instructionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_instructionBtn setTitle:@"帮助" forState:UIControlStateNormal];
    [_instructionBtn setTitleColor:RGBCOLOR(57, 138, 228) forState:UIControlStateNormal];
    _instructionBtn.titleLabel.font = kSmallFont;
    _instructionBtn.backgroundColor = [UIColor clearColor];
    [_instructionBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_instructionBtn addTarget:self action:@selector(instructionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPane addSubview:_instructionBtn];
}

/**
 初始化右边题号面板
 */
- (void)initRightPane {
    _rightPane = [[ERightPane alloc] init];
    _rightPane.backgroundColor = [UIColor whiteColor];
    _rightPane.delegate = self;
    [self addSubview:_rightPane];
    
    // 创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 创建collectionView 通过一个布局策略layout来创建
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collect.backgroundColor = [UIColor whiteColor];
    collect.showsVerticalScrollIndicator = NO;
    // 代理设置
    collect.delegate = self;
    collect.dataSource = self;
    // 注册item类型 这里使用系统的类型
    [collect registerClass:[EBlockCell class] forCellWithReuseIdentifier:@"EBlockCell"];
    // 注册header
    [collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    // 注册footer
    [collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    
    _numberView = collect;
    
    [_rightPane addSubview:_numberView];
    
    _rightScrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightScrollBtn setImage:IMAGE_BY_NAMED(@"rightScrollBtn") forState:UIControlStateNormal];
    [_rightScrollBtn setImage:IMAGE_BY_NAMED(@"rightScrollBtn") forState:UIControlStateHighlighted];
    _rightScrollBtn.backgroundColor = [UIColor clearColor];
    [_rightScrollBtn addTarget:self action:@selector(showRightNumber) forControlEvents:UIControlEventTouchUpInside];
    _rightScrollBtn.userInteractionEnabled = NO;
    [_rightPane addSubview:_rightScrollBtn];
}

- (UIView *)buildNumberViewHeader {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _numberView.bounds.size.width, kEPadding)];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

- (UIView *)buildNumberViewFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _numberView.bounds.size.width, kEPadding)];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

/**
 初始化试题面板
 */
- (void)initExercisePane {
    _exercisePane = [[UIView alloc] init];
    _exercisePane.backgroundColor = [UIColor whiteColor];
    [self addSubview:_exercisePane];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_exercisePane addSubview:_scrollView];
    
    _kindLbl = [[UILabel alloc] init];
    _kindLbl.font = kTinyFont;
    _kindLbl.backgroundColor = RGBCOLOR(123, 153, 217);
    _kindLbl.numberOfLines = 0;
    _kindLbl.layer.cornerRadius = 2.f;
    _kindLbl.layer.masksToBounds = YES;
    _kindLbl.text = @"必";
    _kindLbl.textColor = [UIColor whiteColor];
    _kindLbl.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_kindLbl];
    
    _questionLbl = [[UILabel alloc] init];
    _questionLbl.font = kSmallFont;
    _questionLbl.backgroundColor = [UIColor clearColor];
    _questionLbl.numberOfLines = 0;
    [_scrollView addSubview:_questionLbl];
    
    _checkbox1 = [[CTCheckbox alloc] init];
    [_checkbox1 setBackgroundColor:RGBCOLOR(222, 224, 220) forControlState:UIControlStateNormal];
    _checkbox1.textLabel.font = kSmallFont;
    _checkbox1.textLabel.backgroundColor = [UIColor clearColor];
    _checkbox1.textLabel.numberOfLines = 20;
    _checkbox1.tag = 1000;
    _checkbox1.layer.cornerRadius = 2.f;
    _checkbox1.layer.masksToBounds = YES;
    [_checkbox1 addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_checkbox1];
    
    _checkbox2 = [[CTCheckbox alloc] init];
    [_checkbox2 setBackgroundColor:RGBCOLOR(222, 224, 220) forControlState:UIControlStateNormal];
    _checkbox2.textLabel.font = kSmallFont;
    _checkbox2.textLabel.backgroundColor = [UIColor clearColor];
    _checkbox2.textLabel.numberOfLines = 20;
    _checkbox2.tag = 1001;
    _checkbox2.layer.cornerRadius = 2.f;
    _checkbox2.layer.masksToBounds = YES;
    [_checkbox2 addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_checkbox2];
    
    _checkbox3 = [[CTCheckbox alloc] init];
    [_checkbox3 setBackgroundColor:RGBCOLOR(222, 224, 220) forControlState:UIControlStateNormal];
    _checkbox3.textLabel.font = kSmallFont;
    _checkbox3.textLabel.backgroundColor = [UIColor clearColor];
    _checkbox3.textLabel.numberOfLines = 20;
    _checkbox3.tag = 1002;
    _checkbox3.layer.cornerRadius = 2.f;
    _checkbox3.layer.masksToBounds = YES;
    [_checkbox3 addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_checkbox3];
    
    _checkbox4 = [[CTCheckbox alloc] init];
    [_checkbox4 setBackgroundColor:RGBCOLOR(222, 224, 220) forControlState:UIControlStateNormal];
    _checkbox4.textLabel.font = kSmallFont;
    _checkbox4.textLabel.backgroundColor = [UIColor clearColor];
    _checkbox4.textLabel.numberOfLines = 20;
    _checkbox4.tag = 1003;
    _checkbox4.layer.cornerRadius = 2.f;
    _checkbox4.layer.masksToBounds = YES;
    [_checkbox4 addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_checkbox4];
}

/**
 初始化底部面板
 */
- (void)initBottomPane {
    _bottomPane = [[UIView alloc] init];
    _bottomPane.layer.borderWidth = 1.f;
    _bottomPane.layer.borderColor = RGBCOLOR(222, 224, 220).CGColor;
    _bottomPane.layer.masksToBounds = YES;
    _bottomPane.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottomPane];
    
    _remainTimeLbl = [[UILabel alloc] init];
    _remainTimeLbl.numberOfLines = 1;
    _remainTimeLbl.textColor = [UIColor darkGrayColor];
    _remainTimeLbl.backgroundColor = [UIColor clearColor];
    _remainTimeLbl.font = kTinyFont;
    _remainTimeLbl.textAlignment = NSTextAlignmentRight;
    _remainTimeLbl.text = @"剩余时间：01:29:59";
    [_bottomPane addSubview:_remainTimeLbl];
    
    _tipLbl = [[UILabel alloc] init];
    _tipLbl.numberOfLines = 1;
    _tipLbl.textColor = [UIColor darkGrayColor];
    _tipLbl.backgroundColor = [UIColor clearColor];
    _tipLbl.font = kTinyFont;
    _tipLbl.textAlignment = NSTextAlignmentRight;
    _tipLbl.text = @"橙色为答错题，绿色为答对题，灰色为未答题";
    [_bottomPane addSubview:_tipLbl];
    _tipLbl.alpha = 0.f;
    
    _scaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scaleBtn setTitle:@"文字缩放" forState:UIControlStateNormal];
    [_scaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _scaleBtn.titleLabel.font = kSmallFont;
    _scaleBtn.backgroundColor = [UIColor clearColor];
    _scaleBtn.layer.borderColor = kThemeColor.CGColor;
    _scaleBtn.layer.borderWidth = 1.f;
    _scaleBtn.layer.cornerRadius = 2.f;
    _scaleBtn.layer.masksToBounds = YES;
    [_scaleBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_scaleBtn addTarget:self action:@selector(scaleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPane addSubview:_scaleBtn];
    
    _previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_previousBtn setTitle:@"上一题" forState:UIControlStateNormal];
    [_previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _previousBtn.titleLabel.font = kSmallFont;
    _previousBtn.backgroundColor = [UIColor clearColor];
    _previousBtn.layer.borderColor = kThemeColor.CGColor;
    _previousBtn.layer.borderWidth = 1.f;
    _previousBtn.layer.cornerRadius = 2.f;
    _previousBtn.layer.masksToBounds = YES;
    [_previousBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_previousBtn addTarget:self action:@selector(previousBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPane addSubview:_previousBtn];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = kSmallFont;
    _nextBtn.backgroundColor = [UIColor clearColor];
    _nextBtn.layer.borderColor = kThemeColor.CGColor;
    _nextBtn.layer.borderWidth = 1.f;
    _nextBtn.layer.cornerRadius = 2.f;
    _nextBtn.layer.masksToBounds = YES;
    [_nextBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPane addSubview:_nextBtn];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setTitle:@"交卷" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _commitBtn.titleLabel.font = kSmallFont;
    _commitBtn.backgroundColor = [UIColor clearColor];
    _commitBtn.layer.borderColor = kThemeColor.CGColor;
    _commitBtn.layer.borderWidth = 1.f;
    _commitBtn.layer.cornerRadius = 2.f;
    _commitBtn.layer.masksToBounds = YES;
    [_commitBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPane addSubview:_commitBtn];
    
    _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retryBtn setTitle:@"错题重考" forState:UIControlStateNormal];
    [_retryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _retryBtn.titleLabel.font = kSmallFont;
    _retryBtn.backgroundColor = [UIColor clearColor];
    _retryBtn.layer.borderColor = kThemeColor.CGColor;
    _retryBtn.layer.borderWidth = 1.f;
    _retryBtn.layer.cornerRadius = 2.f;
    _retryBtn.layer.masksToBounds = YES;
    [_retryBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_retryBtn addTarget:self action:@selector(retryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPane addSubview:_retryBtn];
}

/**
 初始化弹窗
 */
- (void)initAlertWindow {
    _alertWindow = [EAlertWindow sharedWindow];
    _alertWindow.hidden = YES;
    [self addSubview:_alertWindow];
}

- (void)initInstructionWindow {
    _instructionWindow = [EInstructionWindow sharedWindow];
    _instructionWindow.hidden = YES;
    [self addSubview:_instructionWindow];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGFloat rightPaneWidth = bounds.size.width + 25.f;
#pragma mark - topPane
    _topPane.frame = CGRectMake(0, 0, bounds.size.width, topPaneHeight);
    _titleLbl.frame = CGRectMake((bounds.size.width - topLblWidth) / 2.f, (topPaneHeight - 20.f - topBtnHeight) / 2.f + 20.f, topLblWidth, topBtnHeight);
    _backBtn.frame = CGRectMake(kEPadding, (topPaneHeight - 20.f - topBtnHeight) / 2.f + 20.f, topBtnWidth, topBtnHeight);
    _instructionBtn.frame = CGRectMake(bounds.size.width - kEPadding - 100, _backBtn.frame.origin.y, 100, 24);
#pragma mark - exercisePane
    _exercisePane.frame = CGRectMake(0, topPaneHeight, bounds.size.width - kEPadding * 4, bounds.size.height - topPaneHeight - bottomPaneHeight);
    _scrollView.frame = _exercisePane.bounds;
    CGFloat kindLblHeight = [UILabel getHeightByWidth:20 title:@"必" font:kTinyFont] - 10.f;
    CGFloat kindLblWidth = kindLblHeight;
    _kindLbl.frame = CGRectMake(kEPadding * 2, kEPadding * 2 + 2.f, kindLblWidth, kindLblHeight);
    // 试题label的宽度
    CGFloat lblWidth = _scrollView.bounds.size.width - kEPadding * 4 - _kindLbl.bounds.size.width - kEPadding;
    // 答案label（除去checkbox）的宽度
    CGFloat answerWidth = lblWidth * 2 / 3.f - 10.f - _checkbox1.checkboxSideLength;
    CGFloat answerTextWidth = answerWidth - 10.f - _checkbox1.checkboxSideLength;
    _questionLbl.frame = CGRectMake(_kindLbl.frame.origin.x + _kindLbl.bounds.size.width + kEPadding, kEPadding * 2, lblWidth, [UILabel getHeightByWidth:lblWidth title:[NSString stringWithFormat:@"第%@题  %@",@(_currentQuestion.question_index + 1),_currentQuestion.question_content] font:kSmallFont] - 10.f);
    _checkbox1.frame = CGRectMake(_questionLbl.frame.origin.x, _questionLbl.frame.origin.y + _questionLbl.bounds.size.height + kEPadding, answerWidth, [UILabel getHeightByWidth:answerTextWidth title:[NSString stringWithFormat:@"A.%@",((EAnswer *)_currentQuestion.answers[0]).answer_content] font:kSmallFont]);
    _checkbox2.frame = CGRectMake(_questionLbl.frame.origin.x, _checkbox1.frame.origin.y + _checkbox1.bounds.size.height + kEPadding, answerWidth, [UILabel getHeightByWidth:answerTextWidth title:[NSString stringWithFormat:@"B.%@",((EAnswer *)_currentQuestion.answers[1]).answer_content] font:kSmallFont]);
    UIView *lastView = _checkbox2;
    if (_currentQuestion.answers.count == 3) {
        _checkbox3.frame = CGRectMake(_questionLbl.frame.origin.x, _checkbox2.frame.origin.y + _checkbox2.bounds.size.height + kEPadding, answerWidth, [UILabel getHeightByWidth:answerTextWidth title:[NSString stringWithFormat:@"C.%@",((EAnswer *)_currentQuestion.answers[2]).answer_content] font:kSmallFont]);
        lastView = _checkbox3;
    } else if (_currentQuestion.answers.count == 4) {
        _checkbox3.frame = CGRectMake(_questionLbl.frame.origin.x, _checkbox2.frame.origin.y + _checkbox2.bounds.size.height + kEPadding, answerWidth, [UILabel getHeightByWidth:answerTextWidth title:[NSString stringWithFormat:@"C.%@",((EAnswer *)_currentQuestion.answers[2]).answer_content] font:kSmallFont]);
        _checkbox4.frame = CGRectMake(_questionLbl.frame.origin.x, _checkbox3.frame.origin.y + _checkbox3.bounds.size.height + kEPadding, answerWidth, [UILabel getHeightByWidth:answerTextWidth title:[NSString stringWithFormat:@"D.%@",((EAnswer *)_currentQuestion.answers[3]).answer_content] font:kSmallFont]);
        lastView = _checkbox4;
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, lastView.frame.origin.y + lastView.bounds.size.height + kEPadding);
#pragma mark - bottomPane
    _bottomPane.frame = CGRectMake(0, bounds.size.height - bottomPaneHeight, bounds.size.width, bottomPaneHeight);
    switch (_type) {
        case ExamPaneTypeExercise:
        case ExamPaneTypeRetry:
        {
            _scaleBtn.hidden = NO;
            _scaleBtn.frame = CGRectMake(kEPadding * 2, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
            _retryBtn.hidden = YES;
            if (_currentQuestion.question_index == 0) {
                _previousBtn.hidden = YES;
                _nextBtn.hidden = NO;
                _nextBtn.frame = CGRectMake(_scaleBtn.frame.origin.x + bottomBtnWidth + kEPadding * 3, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
                _commitBtn.hidden = YES;
            } else {
                if (_currentQuestion.question_index == [self getQuestionTotalCount] - 1) {
                    _previousBtn.hidden = NO;
                    _previousBtn.frame = CGRectMake(_scaleBtn.frame.origin.x + bottomBtnWidth + kEPadding * 3, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
                    _nextBtn.hidden = YES;
                    _commitBtn.hidden = NO;
                    _commitBtn.frame = CGRectMake(_previousBtn.frame.origin.x + kEPadding * 3 + bottomBtnWidth, _previousBtn.frame.origin.y, bottomBtnWidth, bottomBtnHeight);
                } else {
                    _previousBtn.hidden = NO;
                    _previousBtn.frame = CGRectMake(_scaleBtn.frame.origin.x + bottomBtnWidth + kEPadding * 3, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
                    _nextBtn.hidden = NO;
                    _nextBtn.frame = CGRectMake(_previousBtn.frame.origin.x + kEPadding * 3 + bottomBtnWidth, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
                    _commitBtn.hidden = YES;
                }
            }
        }
            break;
        case ExamPaneTypeView:
        {
            _scaleBtn.hidden = YES;
            _retryBtn.hidden = YES;
            _commitBtn.hidden = YES;
            if (_currentQuestion.question_index == 0) {
                _previousBtn.hidden = YES;
                _nextBtn.hidden = NO;
                _nextBtn.frame = CGRectMake(kEPadding * 2, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
            } else {
                if (_currentQuestion.question_index == [self getQuestionTotalCount] - 1) {
                    _previousBtn.hidden = NO;
                    _previousBtn.frame = CGRectMake(kEPadding * 2, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
                    _nextBtn.hidden = YES;
                } else {
                    _previousBtn.hidden = NO;
                    _previousBtn.frame = CGRectMake(kEPadding * 2, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
                    _nextBtn.hidden = NO;
                    _nextBtn.frame = CGRectMake(_previousBtn.frame.origin.x + kEPadding * 3 + bottomBtnWidth, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
                }
            }
        }
            break;
        case ExamPaneTypeCheck:
        {
            _scaleBtn.hidden = NO;
            _scaleBtn.frame = CGRectMake(kEPadding * 2, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
            _retryBtn.hidden = NO;
            _retryBtn.frame = CGRectMake(_scaleBtn.frame.origin.x + bottomBtnWidth + kEPadding * 3, (bottomPaneHeight - bottomBtnHeight) / 2.f, bottomBtnWidth, bottomBtnHeight);
            _previousBtn.hidden = YES;
            _nextBtn.hidden = YES;
            _commitBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
    CGFloat timeLblWidth = [UILabel getWidthWithTitle:_remainTimeLbl.text font:_remainTimeLbl.font] + 5.f;
    CGFloat timeLblHeight = 15.f;
    _remainTimeLbl.frame = CGRectMake(_bottomPane.bounds.size.width - kEPadding - timeLblWidth, kEPadding, timeLblWidth, timeLblHeight);
    CGFloat tipLblWidth = [UILabel getWidthWithTitle:_tipLbl.text font:_tipLbl.font] + 5.f;
    CGFloat tipLblHeight = 15.f;
    _tipLbl.frame = CGRectMake(_bottomPane.bounds.size.width - kEPadding - tipLblWidth, kEPadding, tipLblWidth, tipLblHeight);
#pragma mark - rightPane
    _rightPane.frame = CGRectMake(_isRightPaneShowing?0:bounds.size.width - rightScrollBtnWidth, topPaneHeight, rightPaneWidth, bounds.size.height - topPaneHeight - bottomPaneHeight);
    _numberView.frame = CGRectMake(kEPadding * 2 + rightScrollBtnWidth, 0, _rightPane.bounds.size.width - kEPadding * 4 - rightScrollBtnWidth, _rightPane.bounds.size.height);
    CGPoint newPoint = [self convertPoint:CGPointMake(0, (self.bounds.size.height - rightScrollBtnHeight) / 2.f) toView:_rightPane];
    _rightScrollBtn.frame = CGRectMake(0, newPoint.y, rightScrollBtnWidth, rightScrollBtnHeight);
#pragma mark - Window
    _alertWindow.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    _instructionWindow.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}

#pragma mark - collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _questions.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(_numberView.bounds.size.width, kEPadding);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(_numberView.bounds.size.width, kEPadding);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        for (UIView *view in footerView.subviews) {
            [view removeFromSuperview];
        }
        
        footerView.backgroundColor = [UIColor clearColor];
        
        reusableview = footerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        for (UIView *view in footerView.subviews) {
            [view removeFromSuperview];
        }
        
        footerView.backgroundColor = [UIColor clearColor];
        
        reusableview = footerView;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat blockWidth = (_rightPane.bounds.size.width - (numberOfCols + 1) * kEPadding) / numberOfCols;
    CGFloat blockHeight = blockWidth * 0.618;
    CGSize itemSize = CGSizeMake(blockWidth, blockHeight);
    return itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EBlockCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EBlockCell" forIndexPath:indexPath];
    cell.indicatorImgView.hidden = YES;
    cell.titleLbl.textAlignment = NSTextAlignmentCenter;
    CGFloat blockWidth = (_rightPane.bounds.size.width - (numberOfCols + 1) * kEPadding) / numberOfCols;
    CGFloat blockHeight = blockWidth * 0.618;
    [cell refreshSize:CGSizeMake(blockWidth, blockHeight)];
    cell.backgroundColor = [UIColor clearColor];
    EQuestion *question = _questions[indexPath.row];
    UIColor *blockBgColor = HEXCOLOR(0xc0c0c0);
    switch (question.answer_type) {
        case EAnswerTypeBlank:
        {
            blockBgColor = HEXCOLOR(0xc0c0c0); // 灰色
        }
            break;
        case EAnswerTypeWrong:
        {
            blockBgColor = HEXCOLOR(0xf9a041); // 橙色
        }
            break;
        case EAnswerTypeRight:
        {
            blockBgColor = HEXCOLOR(0x7fdb83); // 绿色
        }
            break;
        default:
        {
            blockBgColor = HEXCOLOR(0xc0c0c0);
        }
            break;
    }
    [cell refreshWithTitle:[NSString stringWithFormat:@"%@",@(question.question_index + 1)] background:[UIImage e_imageWithColor:blockBgColor]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self numberActionAtSection:indexPath.section row:indexPath.row];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - ERightPaneDelegate

- (void)rightPaneDidPan {
    _rightPaneDidPan = YES;
}

- (void)toLeft {
    [self showRightPane:YES];
}

- (void)toRight {
    [self showRightPane:NO];
}

#pragma mark - public methods

- (void)refreshCheckboxHeartColor:(UIColor *)color {
    [_checkbox1 setHeartColor:color];
    [_checkbox2 setHeartColor:color];
    [_checkbox3 setHeartColor:color];
    [_checkbox4 setHeartColor:color];
}

- (void)refreshCheckboxBackgroundColor:(UIColor *)color {
    _checkboxSelectedBgColor = color;
}

- (void)refreshTitle:(NSString *)title {
    if (title) {
        _titleLbl.text = title;
        [_titleLbl setNeedsDisplay];
    }
}

- (void)refreshQuestion:(EQuestion *)question lock:(BOOL)lock {
    if (question) {
        _currentQuestion = question;
        if (_currentQuestion.question_is_required == 1) {
            _kindLbl.text = @"必";
            _kindLbl.backgroundColor = RGBCOLOR(123, 153, 217);
        } else {
            _kindLbl.text = [_currentQuestion.question_type substringToIndex:1];
            if ([_currentQuestion.question_type isEqualToString:@"多选题"]) {
                _kindLbl.backgroundColor = RGBCOLOR(159, 219, 137);
            } else {
                _kindLbl.backgroundColor = kThemeColor;
            }
        }
        _questionLbl.text = [NSString stringWithFormat:@"第%@题  %@",@(_currentQuestion.question_index + 1),_currentQuestion.question_content];
        _previousBtn.hidden = _currentQuestion.question_index == 0;
        _nextBtn.hidden = _currentQuestion.question_index == ([self getQuestionTotalCount] - 1);
        _checkbox1.userInteractionEnabled = !lock;
        _checkbox2.userInteractionEnabled = !lock;
        _checkbox3.userInteractionEnabled = !lock;
        _checkbox4.userInteractionEnabled = !lock;
        switch (_currentQuestion.answers.count) {
            case 2:
            {
                _checkbox1.hidden = NO;
                _checkbox2.hidden = NO;
                _checkbox3.hidden = YES;
                _checkbox4.hidden = YES;
                _checkbox1.textLabel.text = [NSString stringWithFormat:@"A.%@",((EAnswer *)_currentQuestion.answers[0]).answer_content];
                _checkbox2.textLabel.text = [NSString stringWithFormat:@"B.%@",((EAnswer *)_currentQuestion.answers[1]).answer_content];
                if (lock) {
                    _checkbox1.checked = ((EAnswer *)_currentQuestion.answers[0]).answer_correct;
                    _checkbox2.checked = ((EAnswer *)_currentQuestion.answers[1]).answer_correct;
                } else {
                    _checkbox1.checked = ((EAnswer *)_currentQuestion.answers[0]).checked;
                    _checkbox2.checked = ((EAnswer *)_currentQuestion.answers[1]).checked;
                }
            }
                break;
            case 3:
            {
                _checkbox1.hidden = NO;
                _checkbox2.hidden = NO;
                _checkbox3.hidden = NO;
                _checkbox4.hidden = YES;
                _checkbox1.textLabel.text = [NSString stringWithFormat:@"A.%@",((EAnswer *)_currentQuestion.answers[0]).answer_content];
                _checkbox2.textLabel.text = [NSString stringWithFormat:@"B.%@",((EAnswer *)_currentQuestion.answers[1]).answer_content];
                _checkbox3.textLabel.text = [NSString stringWithFormat:@"C.%@",((EAnswer *)_currentQuestion.answers[2]).answer_content];
                if (lock) {
                    _checkbox1.checked = ((EAnswer *)_currentQuestion.answers[0]).answer_correct;
                    _checkbox2.checked = ((EAnswer *)_currentQuestion.answers[1]).answer_correct;
                    _checkbox3.checked = ((EAnswer *)_currentQuestion.answers[2]).answer_correct;
                } else {
                    _checkbox1.checked = ((EAnswer *)_currentQuestion.answers[0]).checked;
                    _checkbox2.checked = ((EAnswer *)_currentQuestion.answers[1]).checked;
                    _checkbox3.checked = ((EAnswer *)_currentQuestion.answers[2]).checked;
                }
            }
                break;
            case 4:
            {
                _checkbox1.hidden = NO;
                _checkbox2.hidden = NO;
                _checkbox3.hidden = NO;
                _checkbox4.hidden = NO;
                _checkbox1.textLabel.text = [NSString stringWithFormat:@"A.%@",((EAnswer *)_currentQuestion.answers[0]).answer_content];
                _checkbox2.textLabel.text = [NSString stringWithFormat:@"B.%@",((EAnswer *)_currentQuestion.answers[1]).answer_content];
                _checkbox3.textLabel.text = [NSString stringWithFormat:@"C.%@",((EAnswer *)_currentQuestion.answers[2]).answer_content];
                _checkbox4.textLabel.text = [NSString stringWithFormat:@"D.%@",((EAnswer *)_currentQuestion.answers[3]).answer_content];
                if (lock) {
                    _checkbox1.checked = ((EAnswer *)_currentQuestion.answers[0]).answer_correct;
                    _checkbox2.checked = ((EAnswer *)_currentQuestion.answers[1]).answer_correct;
                    _checkbox3.checked = ((EAnswer *)_currentQuestion.answers[2]).answer_correct;
                    _checkbox4.checked = ((EAnswer *)_currentQuestion.answers[3]).answer_correct;
                } else {
                    _checkbox1.checked = ((EAnswer *)_currentQuestion.answers[0]).checked;
                    _checkbox2.checked = ((EAnswer *)_currentQuestion.answers[1]).checked;
                    _checkbox3.checked = ((EAnswer *)_currentQuestion.answers[2]).checked;
                    _checkbox4.checked = ((EAnswer *)_currentQuestion.answers[3]).checked;
                }
            }
                break;
            default:
                break;
        }
        if (_checkbox1.checked) {
            [_checkbox1 setBackgroundColor:_checkboxSelectedBgColor forControlState:UIControlStateNormal];
        } else {
            [_checkbox1 setBackgroundColor:RGBCOLOR(222, 224, 220) forControlState:UIControlStateNormal];
        }
        if (_checkbox2.checked) {
            [_checkbox2 setBackgroundColor:_checkboxSelectedBgColor forControlState:UIControlStateNormal];
        } else {
            [_checkbox2 setBackgroundColor:RGBCOLOR(222, 224, 220) forControlState:UIControlStateNormal];
        }
        if (_checkbox3.checked) {
            [_checkbox3 setBackgroundColor:_checkboxSelectedBgColor forControlState:UIControlStateNormal];
        } else {
            [_checkbox3 setBackgroundColor:RGBCOLOR(222, 224, 220) forControlState:UIControlStateNormal];
        }
        if (_checkbox4.checked) {
            [_checkbox4 setBackgroundColor:_checkboxSelectedBgColor forControlState:UIControlStateNormal];
        } else {
            [_checkbox4 setBackgroundColor:RGBCOLOR(222, 224, 220) forControlState:UIControlStateNormal];
        }
        _isRightPaneShowing = NO;
        [self setNeedsLayout];
    }
}

- (void)refreshQuestions:(NSArray *)questions {
    if (questions && questions.count > 0) {
        _questions = questions;
        [_numberView reloadData];
    }
}

- (void)showRightNumber {
    [self showRightPane:YES];
}

- (void)hideRightNumber {
    [self showRightPane:NO];
}

- (void)showRightPane:(BOOL)show {
    if (show == _isRightPaneShowing && !_rightPaneDidPan) {
        return;
    }
    __weak typeof (self) weakSelf = self;
    if (show) { // 显示
        [UIView animateWithDuration:0.2 animations:^{
            __strong typeof (self) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            strongSelf->_rightPane.frame = CGRectMake(- rightScrollBtnWidth, strongSelf->_rightPane.frame.origin.y, strongSelf->_rightPane.bounds.size.width, strongSelf->_rightPane.bounds.size.height);
            if (strongSelf->_type == ExamPaneTypeCheck) {
                strongSelf.tipLbl.alpha = 1.f;
            }
        } completion:^(BOOL finished) {
            __strong typeof (self) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            strongSelf->_isRightPaneShowing = YES;
            strongSelf->_rightPaneDidPan = NO;
        }];
    } else { // 隐藏
        [UIView animateWithDuration:0.2 animations:^{
            __strong typeof (self) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            strongSelf->_rightPane.frame = CGRectMake(strongSelf.bounds.size.width - rightScrollBtnWidth, strongSelf->_rightPane.frame.origin.y, strongSelf->_rightPane.bounds.size.width, strongSelf->_rightPane.bounds.size.height);
            if (strongSelf->_type == ExamPaneTypeCheck) {
                strongSelf.tipLbl.alpha = 0.f;
            }
        } completion:^(BOOL finished) {
            __strong typeof (self) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            strongSelf->_isRightPaneShowing = NO;
            strongSelf->_rightPaneDidPan = NO;
        }];
    }
}

@end
