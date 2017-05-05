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
#import "EQuestion.h"
#import "EAnswer.h"
#import "UILabel+Additions.h"

#define topPaneHeight 64.f
#define topLblWidth 120.f
#define topBtnWidth 100.f
#define topBtnHeight 30.f
#define timerPaneHeight 44.f
#define bottomPaneHeight 44.f

#define numberOfCols 4

@interface EExamPane()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    ExamPaneType _type;
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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _questions = [NSMutableArray array];
        [self initTopPane];
        [self initTimerPane];
        [self initRightPane];
        [self initExercisePane];
        [self initBottomPane];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(ExamPaneType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _questions = [NSMutableArray array];
        [self initTopPane];
        [self initTimerPane];
        [self initRightPane];
        [self initExercisePane];
        [self initBottomPane];
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

- (void)numberActionAtSection:(NSInteger)section row:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberBtnClickOnPane:controller:section:row:)]) {
        [self.delegate numberBtnClickOnPane:self controller:self.delegate section:section row:row];
    }
}

#pragma mark - other methods

- (NSInteger)getQuestionTotalCount {
    NSInteger count = 0;
    for (int i = 0; i < _questions.count; i ++) {
        NSArray *group = _questions[i];
        for (int j = 0; j < group.count; j ++) {
            count ++;
        }
    }
    return count;
}

- (void)checkboxDidChange:(CTCheckbox *)checkbox {
    ((EAnswer *)_currentQuestion.answers[checkbox.tag - 1000]).checked = checkbox.checked;
    if (([_currentQuestion.question_type isEqualToString:@"判断题"] || [_currentQuestion.question_type isEqualToString:@"单选题"]) && checkbox.checked) {
        // 其它checkbox取消选中
        for (int i = 0; i < _currentQuestion.answers.count; i ++) {
            CTCheckbox *cb = (CTCheckbox *)[_scrollView viewWithTag:1000 + i];
            if (checkbox.tag - 1000 != i) {
                cb.checked = NO;
            }
        }
    }
}

#pragma mark - init

/**
 初始化顶部面板
 */
- (void)initTopPane {
    _topPane = [[UIView alloc] init];
    _topPane.backgroundColor = kThemeColor;
    [self addSubview:_topPane];
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.backgroundColor = [UIColor clearColor];
    _titleLbl.font = kMediumFont;
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.userInteractionEnabled = YES;
    [_topPane addSubview:_titleLbl];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _backBtn.titleLabel.font = kSmallFont;
    _backBtn.backgroundColor = [UIColor orangeColor];
    [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPane addSubview:_backBtn];
    
    _instructionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_instructionBtn setTitle:@"操作说明" forState:UIControlStateNormal];
    [_instructionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _instructionBtn.titleLabel.font = kSmallFont;
    _instructionBtn.backgroundColor = [UIColor orangeColor];
    [_instructionBtn addTarget:self action:@selector(instructionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPane addSubview:_instructionBtn];
}

/**
 初始化计时器面板
 */
- (void)initTimerPane {
    _timerPane = [[UIView alloc] init];
    _timerPane.backgroundColor = [UIColor whiteColor];
    [self addSubview:_timerPane];
    
    _totalTimeLbl = [[UILabel alloc] init];
    _totalTimeLbl.numberOfLines = 1;
    _totalTimeLbl.textColor = [UIColor blackColor];
    _totalTimeLbl.backgroundColor = [UIColor whiteColor];
    _totalTimeLbl.font = kTinyFont;
    _totalTimeLbl.text = @"考试时间：90分钟";
    [_timerPane addSubview:_totalTimeLbl];
    
    _remainTimeLbl = [[UILabel alloc] init];
    _remainTimeLbl.numberOfLines = 1;
    _remainTimeLbl.textColor = [UIColor blackColor];
    _remainTimeLbl.backgroundColor = [UIColor whiteColor];
    _remainTimeLbl.font = kTinyFont;
    _remainTimeLbl.text = @"剩余时间：0小时25分钟28秒";
    [_timerPane addSubview:_remainTimeLbl];
}

/**
 初始化右边题号面板
 */
- (void)initRightPane {
    _rightPane = [[UIView alloc] init];
    _rightPane.backgroundColor = [UIColor cyanColor];
    [self addSubview:_rightPane];
    
    // 创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 创建collectionView 通过一个布局策略layout来创建
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collect.backgroundColor = [UIColor clearColor];
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
    
    _questionLbl = [[UILabel alloc] init];
    _questionLbl.font = kSmallFont;
    _questionLbl.backgroundColor = [UIColor clearColor];
    _questionLbl.numberOfLines = 0;
    [_scrollView addSubview:_questionLbl];
    
    _checkbox1 = [[CTCheckbox alloc] init];
    _checkbox1.textLabel.font = kSmallFont;
    _checkbox1.textLabel.backgroundColor = [UIColor clearColor];
    _checkbox1.textLabel.numberOfLines = 20;
    _checkbox1.tag = 1000;
    [_checkbox1 addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_checkbox1];
    
    _checkbox2 = [[CTCheckbox alloc] init];
    _checkbox2.textLabel.font = kSmallFont;
    _checkbox2.textLabel.backgroundColor = [UIColor clearColor];
    _checkbox2.textLabel.numberOfLines = 20;
    _checkbox2.tag = 1001;
    [_checkbox2 addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_checkbox2];
    
    _checkbox3 = [[CTCheckbox alloc] init];
    _checkbox3.textLabel.font = kSmallFont;
    _checkbox3.textLabel.backgroundColor = [UIColor clearColor];
    _checkbox3.textLabel.numberOfLines = 20;
    _checkbox3.tag = 1002;
    [_checkbox3 addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_checkbox3];
    
    _checkbox4 = [[CTCheckbox alloc] init];
    _checkbox4.textLabel.font = kSmallFont;
    _checkbox4.textLabel.backgroundColor = [UIColor clearColor];
    _checkbox4.textLabel.numberOfLines = 20;
    _checkbox4.tag = 1003;
    [_checkbox4 addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_checkbox4];
}

/**
 初始化底部面板
 */
- (void)initBottomPane {
    _bottomPane = [[UIView alloc] init];
    _bottomPane.backgroundColor = [UIColor cyanColor];
    [self addSubview:_bottomPane];
    
    _previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_previousBtn setTitle:@"上一题" forState:UIControlStateNormal];
    [_previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _previousBtn.titleLabel.font = kSmallFont;
    _previousBtn.backgroundColor = [UIColor lightGrayColor];
    [_previousBtn addTarget:self action:@selector(previousBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPane addSubview:_previousBtn];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = kSmallFont;
    _nextBtn.backgroundColor = [UIColor lightGrayColor];
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPane addSubview:_nextBtn];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setTitle:@"交卷" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _commitBtn.titleLabel.font = kSmallFont;
    _commitBtn.backgroundColor = [UIColor lightGrayColor];
    [_commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPane addSubview:_commitBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGFloat rightPaneWidth = bounds.size.width / 3.f;
#pragma mark - topPane
    _topPane.frame = CGRectMake(0, 0, bounds.size.width, topPaneHeight);
    _titleLbl.frame = CGRectMake((bounds.size.width - topLblWidth) / 2.f, (topPaneHeight - 20.f - topBtnHeight) / 2.f + 20.f, topLblWidth, topBtnHeight);
    _backBtn.frame = CGRectMake(kEPadding, (topPaneHeight - 20.f - topBtnHeight) / 2.f + 20.f, topBtnWidth, topBtnHeight);
    _instructionBtn.frame = CGRectMake(bounds.size.width - kEPadding - topBtnWidth, _backBtn.frame.origin.y, topBtnWidth, topBtnHeight);
#pragma mark - timerPane
    if (_type == ExamPaneTypeBlank) {
        _timerPane.frame = CGRectMake(bounds.size.width - rightPaneWidth, topPaneHeight, rightPaneWidth, timerPaneHeight);
        _totalTimeLbl.frame = CGRectMake(0, 0, rightPaneWidth, timerPaneHeight / 2.f);
        _remainTimeLbl.frame = CGRectMake(0, _totalTimeLbl.bounds.size.height, _totalTimeLbl.bounds.size.width, _totalTimeLbl.bounds.size.height);
    } else {
        _timerPane.hidden = YES;
    }
#pragma mark - rightPane
    if (_timerPane.isHidden) {
        _rightPane.frame = CGRectMake(bounds.size.width - rightPaneWidth, topPaneHeight, rightPaneWidth, bounds.size.height - topPaneHeight);
    } else {
        _rightPane.frame = CGRectMake(bounds.size.width - rightPaneWidth, topPaneHeight + timerPaneHeight, rightPaneWidth, bounds.size.height - topPaneHeight - timerPaneHeight);
    }
    _numberView.frame = CGRectMake(kEPadding, 0, _rightPane.bounds.size.width - kEPadding * 2, _rightPane.bounds.size.height);
#pragma mark - exercisePane
    _exercisePane.frame = CGRectMake(0, topPaneHeight, bounds.size.width - rightPaneWidth - kEPadding / 2.f, bounds.size.height - topPaneHeight - bottomPaneHeight);
    _scrollView.frame = _exercisePane.bounds;
    // 试题label的宽度
    CGFloat lblWidth = _scrollView.bounds.size.width - kEPadding * 2;
    // 答案label（除去checkbox）的宽度
    CGFloat answerWidth = lblWidth - 5.f - _checkbox1.checkboxSideLength;
    _questionLbl.frame = CGRectMake(kEPadding, kEPadding, lblWidth, [UILabel getHeightByWidth:lblWidth title:[NSString stringWithFormat:@"第%@题 %@ %@",@(_currentQuestion.question_index + 1),_currentQuestion.question_type,_currentQuestion.question_content] font:kSmallFont]);
    _checkbox1.frame = CGRectMake(kEPadding, _questionLbl.frame.origin.y + _questionLbl.bounds.size.height + kEPadding, lblWidth, [UILabel getHeightByWidth:answerWidth title:[NSString stringWithFormat:@"A.%@",((EAnswer *)_currentQuestion.answers[0]).answer_content] font:kSmallFont]);
    _checkbox2.frame = CGRectMake(kEPadding, _checkbox1.frame.origin.y + _checkbox1.bounds.size.height + kEPadding, lblWidth, [UILabel getHeightByWidth:answerWidth title:[NSString stringWithFormat:@"B.%@",((EAnswer *)_currentQuestion.answers[1]).answer_content] font:kSmallFont]);
    UIView *lastView = _checkbox2;
    if (_currentQuestion.answers.count == 3) {
        _checkbox3.frame = CGRectMake(kEPadding, _checkbox2.frame.origin.y + _checkbox2.bounds.size.height + kEPadding, lblWidth, [UILabel getHeightByWidth:answerWidth title:[NSString stringWithFormat:@"C.%@",((EAnswer *)_currentQuestion.answers[2]).answer_content] font:kSmallFont]);
        lastView = _checkbox3;
    } else if (_currentQuestion.answers.count == 4) {
        _checkbox3.frame = CGRectMake(kEPadding, _checkbox2.frame.origin.y + _checkbox2.bounds.size.height + kEPadding, lblWidth, [UILabel getHeightByWidth:answerWidth title:[NSString stringWithFormat:@"C.%@",((EAnswer *)_currentQuestion.answers[2]).answer_content] font:kSmallFont]);
        _checkbox4.frame = CGRectMake(kEPadding, _checkbox3.frame.origin.y + _checkbox3.bounds.size.height + kEPadding, lblWidth, [UILabel getHeightByWidth:answerWidth title:[NSString stringWithFormat:@"D.%@",((EAnswer *)_currentQuestion.answers[3]).answer_content] font:kSmallFont]);
        lastView = _checkbox4;
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, lastView.frame.origin.y + lastView.bounds.size.height + kEPadding);
#pragma mark - bottomPane
    _bottomPane.frame = CGRectMake(0, bounds.size.height - bottomPaneHeight, _exercisePane.bounds.size.width, bottomPaneHeight);
    _topPane.frame = CGRectMake(0, 0, bounds.size.width, topPaneHeight);
    CGFloat bottomBtnWidth = (_bottomPane.bounds.size.width - kEPadding * 7) / 4.f;
    if (_currentQuestion.question_index == 0) {
        _nextBtn.frame = CGRectMake(kEPadding, (bottomPaneHeight - topBtnHeight) / 2.f, bottomBtnWidth, topBtnHeight);
        _commitBtn.frame = CGRectMake(_nextBtn.frame.origin.x + kEPadding * 3 + bottomBtnWidth, _nextBtn.frame.origin.y, bottomBtnWidth, topBtnHeight);
    } else {
        if (_currentQuestion.question_index == [self getQuestionTotalCount] - 1) {
            _previousBtn.frame = CGRectMake(kEPadding, (bottomPaneHeight - topBtnHeight) / 2.f, bottomBtnWidth, topBtnHeight);
            _commitBtn.frame = CGRectMake(_previousBtn.frame.origin.x + kEPadding * 3 + bottomBtnWidth, _previousBtn.frame.origin.y, bottomBtnWidth, topBtnHeight);
        } else {
            _previousBtn.frame = CGRectMake(kEPadding, (bottomPaneHeight - topBtnHeight) / 2.f, bottomBtnWidth, topBtnHeight);
            _nextBtn.frame = CGRectMake(_previousBtn.frame.origin.x + kEPadding + bottomBtnWidth, (bottomPaneHeight - topBtnHeight) / 2.f, bottomBtnWidth, topBtnHeight);
            _commitBtn.frame = CGRectMake(_nextBtn.frame.origin.x + kEPadding * 3 + bottomBtnWidth, _nextBtn.frame.origin.y, bottomBtnWidth, topBtnHeight);
        }
    }
}

#pragma mark - collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _questions.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((NSArray *)_questions[section]).count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(_rightPane.bounds.size.width - kEPadding * 2, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section < _questions.count - 1) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(_rightPane.bounds.size.width - kEPadding * 2, kEPadding);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionReusableView *reusableview = nil;
        
        if (kind == UICollectionElementKindSectionHeader){
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            for (UIView *view in headerView.subviews) {
                [view removeFromSuperview];
            }
            
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kEPadding, headerView.bounds.size.width, headerView.bounds.size.height - kEPadding * 2)];
            titleLbl.backgroundColor = [UIColor clearColor];
            titleLbl.textColor = [UIColor blackColor];
            titleLbl.font = kMediumFont;
            
            NSString *title = ((EQuestion *)_questions[indexPath.section][0]).question_type;
            
            titleLbl.text = title;
            
            headerView.backgroundColor = [UIColor clearColor];
            [headerView addSubview:titleLbl];
            
            reusableview = headerView;
        } else if (kind == UICollectionElementKindSectionFooter) {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            for (UIView *view in footerView.subviews) {
                [view removeFromSuperview];
            }
            
            footerView.backgroundColor = [UIColor clearColor];
            
            reusableview = footerView;
        }
        
        return reusableview;
    } else if (indexPath.section == 1) {
        UICollectionReusableView *reusableview = nil;
        
        if (kind == UICollectionElementKindSectionHeader){
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            for (UIView *view in headerView.subviews) {
                [view removeFromSuperview];
            }
            
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kEPadding, headerView.bounds.size.width, headerView.bounds.size.height - kEPadding * 2)];
            titleLbl.backgroundColor = [UIColor clearColor];
            titleLbl.textColor = [UIColor blackColor];
            titleLbl.font = kMediumFont;
            
            NSString *title = ((EQuestion *)_questions[indexPath.section][0]).question_type;
            
            titleLbl.text = title;
            
            headerView.backgroundColor = [UIColor clearColor];
            [headerView addSubview:titleLbl];
            
            reusableview = headerView;
        } else if (kind == UICollectionElementKindSectionFooter) {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            for (UIView *view in footerView.subviews) {
                [view removeFromSuperview];
            }
            
            footerView.backgroundColor = [UIColor clearColor];
            
            reusableview = footerView;
        }
        
        return reusableview;
    } else {
        UICollectionReusableView *reusableview = nil;
        
        if (kind == UICollectionElementKindSectionHeader){
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            for (UIView *view in headerView.subviews) {
                [view removeFromSuperview];
            }
            
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kEPadding, headerView.bounds.size.width, headerView.bounds.size.height - kEPadding * 2)];
            titleLbl.backgroundColor = [UIColor clearColor];
            titleLbl.textColor = [UIColor blackColor];
            titleLbl.font = kMediumFont;
            
            NSString *title = ((EQuestion *)_questions[indexPath.section][0]).question_type;
            
            titleLbl.text = title;
            
            headerView.backgroundColor = [UIColor clearColor];
            [headerView addSubview:titleLbl];
            
            reusableview = headerView;
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
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat blockWidth = (_rightPane.bounds.size.width - (numberOfCols + 1) * kEPadding) / numberOfCols;
    CGFloat blockHeight = blockWidth * 0.618;
    CGSize itemSize = CGSizeMake(blockWidth, blockHeight);
    return itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EBlockCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EBlockCell" forIndexPath:indexPath];
    CGFloat blockWidth = (_rightPane.bounds.size.width - (numberOfCols + 1) * kEPadding) / numberOfCols;
    CGFloat blockHeight = blockWidth * 0.618;
    [cell refreshSize:CGSizeMake(blockWidth, blockHeight)];
    cell.backgroundColor = [UIColor clearColor];
    EQuestion *question = _questions[indexPath.section][indexPath.row];
    [cell refreshWithTitle:[NSString stringWithFormat:@"%@",@(question.question_index + 1)] background:[UIImage e_imageWithColor:[UIColor lightGrayColor]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self numberActionAtSection:indexPath.section row:indexPath.row];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - public methods

- (void)refreshTitle:(NSString *)title {
    if (title) {
        _titleLbl.text = title;
        [_titleLbl setNeedsDisplay];
    }
}

- (void)refreshQuestion:(EQuestion *)question {
    if (question) {
        _currentQuestion = question;
        _questionLbl.text = [NSString stringWithFormat:@"第%@题 %@ %@",@(_currentQuestion.question_index + 1),_currentQuestion.question_type,_currentQuestion.question_content];
        _previousBtn.hidden = _currentQuestion.question_index == 0;
        _nextBtn.hidden = _currentQuestion.question_index == ([self getQuestionTotalCount] - 1);
        switch (_currentQuestion.answers.count) {
            case 2:
            {
                _checkbox1.hidden = NO;
                _checkbox2.hidden = NO;
                _checkbox3.hidden = YES;
                _checkbox4.hidden = YES;
                _checkbox1.textLabel.text = [NSString stringWithFormat:@"A.%@",((EAnswer *)_currentQuestion.answers[0]).answer_content];
                _checkbox2.textLabel.text = [NSString stringWithFormat:@"B.%@",((EAnswer *)_currentQuestion.answers[1]).answer_content];
                _checkbox1.checked = ((EAnswer *)_currentQuestion.answers[0]).checked;
                _checkbox2.checked = ((EAnswer *)_currentQuestion.answers[1]).checked;
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
                _checkbox1.checked = ((EAnswer *)_currentQuestion.answers[0]).checked;
                _checkbox2.checked = ((EAnswer *)_currentQuestion.answers[1]).checked;
                _checkbox3.checked = ((EAnswer *)_currentQuestion.answers[2]).checked;
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
                _checkbox1.checked = ((EAnswer *)_currentQuestion.answers[0]).checked;
                _checkbox2.checked = ((EAnswer *)_currentQuestion.answers[1]).checked;
                _checkbox3.checked = ((EAnswer *)_currentQuestion.answers[2]).checked;
                _checkbox4.checked = ((EAnswer *)_currentQuestion.answers[3]).checked;
            }
                break;
            default:
                break;
        }
        [self setNeedsLayout];
    }
}

- (void)refreshQuestions:(NSArray *)questions {
    if (questions && questions.count > 0) {
        _questions = questions;
        [_numberView reloadData];
    }
}

@end
