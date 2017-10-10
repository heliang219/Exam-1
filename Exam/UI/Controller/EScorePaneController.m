//
//  EScorePaneController.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EScorePaneController.h"
#import "EScorePane.h"
#import "EExamContainer.h"
#import "EMainTypeController.h"
#import "EQuestion.h"
#import "EDBHelper.h"
#import "EApiClient.h"

@interface EScorePaneController ()<EScorePaneDelegate>
{
    ScorePaneType _type;
    NSString *_topTitle;
    BOOL _needLoading;
}

@property (nonatomic,assign) BOOL fullScreen;  // 是否是全屏
@property (nonatomic,assign) UIInterfaceOrientation currentOrientation; // 当前的方向
@property (nonatomic,assign) BOOL statusbarHidden;  // 状态条是否隐藏
@property (nonatomic,assign) UIInterfaceOrientation orientationWhenFullScreen; // 记住全屏时画面的方向，用来决定弹框方向，<8.3的bug
@property (nonatomic,assign) BOOL isLowIOS; // iOS版本是否小于8.3
@property (nonatomic,weak) UIViewController *superViewController;
@property (nonatomic,strong) EScorePane *scorePane;
@property (nonatomic,assign) CGRect originFrame;  // 初始化尺寸
@property (nonatomic,strong,readwrite) NSArray *questions;  // 所有试题
@property (nonatomic,strong) EExam *exam;

@end

@implementation EScorePaneController

#pragma mark - Life Cycle

- (instancetype)initWithQuestions:(NSArray *)questions {
    self = [super init];
    if (self) {
        _questions = questions;
        _isLowIOS = NO;
        _needLoading = YES;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.4f) {
            _isLowIOS = YES;
        }
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _originFrame.size = CGSizeMake(MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height));
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title questions:(NSArray *)questions exam:(EExam *)exam {
    self = [self initWithQuestions:questions];
    if (self) {
        _topTitle = title;
        if ([_topTitle isEqualToString:@"模拟练习成绩"]) {
            _type = ScorePaneTypeExercise;
        } else if ([_topTitle isEqualToString:@"练习复卷成绩"]) {
            _type = ScorePaneTypeCheck;
        }
        _exam = exam;
    }
    return self;
}

- (void)loadView {
    self.view = [[EExamContainer alloc] initWithFrame:_originFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scorePane = [[EScorePane alloc] initWithFrame:self.view.bounds type:_type];
    self.scorePane.delegate = self;
    [self.view addSubview:self.scorePane];
    
    [self refreshTitle:_topTitle];
    [self calculateScores];
    
    [self setFullScreen:YES WithAnimation:NO];
}

- (void)goBack {
    [((EExamContainer *)self.view).containerView addSubview:self.view];
    [self.view.window makeKeyAndVisible];
    
    if (!self.view.window) {
        return;
    }
    
    // 重置设备方向
    _orientationWanted = UIInterfaceOrientationPortrait;
    [self setFullScreen:NO WithAnimation:NO];
    
    EMainTypeController *mainTypeController = [[EMainTypeController alloc] init];
    [self.navigationController pushToController:mainTypeController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_needLoading) {
        NSString *accessToken = [kUserDefaults objectForKey:kAccess_Token];
        NSMutableArray *questionsResponses = [NSMutableArray array];
        for (EQuestion *question in self.questions) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"question_id"] = @(question.question_id);
            dic[@"answer"] = question.selectedAnswerString;
            dic[@"correct"] = @(question.answer_type == EAnswerTypeRight);
            [questionsResponses addObject:dic];
        }
        WEAK
        [[EApiClient sharedClient] examCommit:accessToken startTime:_exam.startTime endTime:_exam.endTime totalQuestionCount:_questions.count correctQuestionCount:_exam.correctCount isPass:_exam.is_pass questionResponse:questionsResponses completion:^(id responseObject, NSError *error) {
            STRONG
            if (responseObject) {
                DLog(@"提交成功");
            } else {
                DLog(@"提交失败");
            }
            strongSelf->_needLoading = NO;
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _needLoading = NO;
}

- (void)dealloc {
    DLog(@"EScorePaneController即将释放");
}

+ (instancetype)createWithController:(UIViewController *)controller view:(UIView *)view delegate:(id<EScorePaneControllerDelegate>)delegate title:(NSString *)title questions:(NSArray *)questions exam:(EExam *)exam {
    EScorePaneController *scoreVC = [[EScorePaneController alloc] initWithTitle:title questions:questions exam:exam];
    scoreVC.delegate = delegate;
    [view addSubview:scoreVC.view];
    [controller addChildViewController:scoreVC];
    [scoreVC didMoveToParentViewController:controller];
    return scoreVC;
}

#pragma mark - 全屏处理、旋转 退出全屏 进入全屏

/**
 设置全屏
 
 @param fullScreen 是否全屏，YES，全屏
 @param useAnimation 是否使用动画，YES，使用动画效果
 */
- (void)setFullScreen:(BOOL)fullScreen WithAnimation:(BOOL)useAnimation {
    __block UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    if (_fullScreen == fullScreen) {
        if (fullScreen) {
            if (_currentOrientation != orientation && UIInterfaceOrientationIsLandscape(orientation)) {
                // 执行转屏动画
                __weak typeof (self) weakSelf = self;
                [UIView animateWithDuration:.3 animations:^(){
                    __strong typeof (self) strongSelf = weakSelf;
                    if (!strongSelf) {
                        return;
                    }
                    [strongSelf rotate:orientation];
                } completion:^(BOOL finished){
                }];
            }
        }
        return;
    }
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    _fullScreen = fullScreen;
    BOOL hiddenStatusbar = _statusbarHidden;
    if (fullScreen) {
        _statusbarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
        UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            orientation = (UIInterfaceOrientation)deviceOrientation;
        } else {
            orientation = UIInterfaceOrientationLandscapeRight;
        }
        _orientationWhenFullScreen = orientation;
    } else {
        orientation = _orientationWanted;
    }
    if (!_isLowIOS) {
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:hiddenStatusbar];
    
    __weak typeof (self) weakSelf = self;
    void (^rotateTrans)() = ^{
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (fullScreen) {
            [strongSelf rotate:orientation];
            strongSelf->_superViewController = strongSelf.parentViewController;
            [strongSelf willMoveToParentViewController:nil];
            [strongSelf removeFromParentViewController];
            
            CGRect rect = [UIScreen mainScreen].bounds;
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            rect.size = CGSizeMake(MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height));
            strongSelf->_scorePane.frame = rect;
        } else {
            [strongSelf rotate:orientation];
            if (strongSelf->_superViewController) {
                [strongSelf->_superViewController addChildViewController:strongSelf];
                [strongSelf didMoveToParentViewController:strongSelf->_superViewController];
                strongSelf->_superViewController = nil;
            }
            strongSelf->_scorePane.frame = strongSelf.view.bounds;
            [strongSelf.view addSubview:strongSelf->_scorePane];
        }
    };
    if (useAnimation) {
        // 执行转屏动画
        __weak typeof (self) weakSelf = self;
        [UIView animateWithDuration:.3 animations:^(){
            rotateTrans();
        } completion:^(BOOL finished){
            __strong typeof (self) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            [strongSelf->_scorePane setNeedsLayout];
        }];
    } else {
        rotateTrans();
        [_scorePane setNeedsLayout];
    }
}

#pragma mark - other

// 计算得分
- (void)calculateScores {
    CGFloat correct_count = 0.f;
    NSInteger required_count = 0;
    NSInteger required_correct_count = 0;
    BOOL is_pass = NO;
    for (EQuestion *question in self.questions) {
        if (question.question_is_required != 1) { // 非必知必会题
            if (question.answer_type == EAnswerTypeRight) {
                correct_count ++;
            }
        } else { // 必知必会题
            required_count ++;
            if (question.answer_type == EAnswerTypeRight) {
                required_correct_count ++;
            }
        }
    }
    NSInteger total_count = self.questions.count - required_count;
    NSInteger score = (int)(correct_count / total_count * 100);
    is_pass = required_correct_count == required_count;
    if (required_correct_count < required_count) {
        is_pass = NO;
    } else {
        is_pass = (score >= 80);
    }
    EExam *exam = [[EExam alloc] init];
    exam.is_pass = is_pass;
    exam.score = score;
    BOOL insertSuccess = [[EDBHelper defaultHelper] insertExam:exam];
    NSInteger avg_score = score;
    if (insertSuccess) {
        avg_score = [[EDBHelper defaultHelper] queryAverageScore];
    }
    NSString *scoreStr = [NSString stringWithFormat:@"%@分",@(score)];
    NSString *avgScoreStr = [NSString stringWithFormat:@"%@分",@(avg_score)];
    if (_type == ScorePaneTypeExercise) {
        [_scorePane refreshScore:scoreStr average:avgScoreStr];
    } else {
        NSInteger max_score = score;
        NSInteger counts = 1;
        if (insertSuccess) {
            max_score = [[EDBHelper defaultHelper] queryMaxScore];
            counts = [[EDBHelper defaultHelper] queryExamCount];
        }
        NSString *maxScoreStr = [NSString stringWithFormat:@"%@分",@(max_score)];
        NSString *countsStr = [NSString stringWithFormat:@"%@次",@(counts)];
        [_scorePane refreshScore:scoreStr average:avgScoreStr max:maxScoreStr counts:countsStr];
    }
}

#pragma mark - 旋转

- (void)rotate:(UIInterfaceOrientation)orientation {
    if (!UIInterfaceOrientationIsLandscape(orientation) && !UIInterfaceOrientationIsPortrait(orientation)) return;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            transform = CGAffineTransformIdentity;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(M_PI * 1.5);
            break;
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(M_PI * 0.5);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(M_PI * 1.0);
            break;
        default :
            break;
    }
    _scorePane.transform = transform;
    _currentOrientation = orientation;
}

#pragma mark - EExamPaneDelegate

- (void)backBtnClickedOnPane:(UIView *)pane controller:(id<EScorePaneDelegate>)controller {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClicked)]) {
        [self.delegate backBtnClicked];
    }
}

- (void)bottomBtnClickedOnPane:(UIView *)pane controller:(id<EScorePaneDelegate>)controller {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomBtnClicked)]) {
        [self.delegate bottomBtnClicked];
    }
}

#pragma mark - public methods

- (void)refreshTitle:(NSString *)title {
    [self.scorePane refreshTitle:title];
}

- (void)refreshScore:(NSString *)score average:(NSString *)average {
    [self.scorePane refreshScore:score average:average];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
