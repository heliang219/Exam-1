//
//  EExamPaneController.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EExamPaneController.h"
#import "EExamContainer.h"
#import "EQuestion.h"
#import "EScorePaneController.h"
#import "EAlertWindow.h"
#import "EScoreContainController.h"

#define totalTimeInSeconds 9

@interface EExamPaneController ()<EExamPaneDelegate,EAlertWindowDelegate>
{
    NSInteger _currentSection;
    NSInteger _currentRow;
    
    NSString *_topTitle;
    
    NSTimer *_remainTimeTimer; // 剩余时间计时器
    
    NSInteger _remainTimeInSeconds; // 剩余时间
}

@property (nonatomic,assign) BOOL fullScreen;  // 是否是全屏
@property (nonatomic,assign) UIInterfaceOrientation currentOrientation; // 当前的方向
@property (nonatomic,assign) BOOL statusbarHidden;  // 状态条是否隐藏
@property (nonatomic,assign) UIInterfaceOrientation orientationWhenFullScreen; // 记住全屏时画面的方向，用来决定弹框方向，<8.3的bug
@property (nonatomic,assign) BOOL isLowIOS; // iOS版本是否小于8.3
@property (nonatomic,weak) UIViewController *superViewController;
@property (nonatomic,strong) EExamPane *examPane;
@property (nonatomic,assign) CGRect originFrame;  // 初始化尺寸
@property (nonatomic,strong,readwrite) NSArray *questions;  // 所有试题
@property (nonatomic,strong,readwrite) EQuestion *currentQuestion;  // 当前试题

@end

@implementation EExamPaneController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _isLowIOS = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 8.4f) {
            _isLowIOS = YES;
        }
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _originFrame.size = CGSizeMake(MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height));
    }
    return self;
}

- (instancetype)initWithQuestions:(NSArray *)questions {
    self = [self init];
    if (self) {
        _questions = questions;
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title questions:(NSArray *)questions {
    self = [self initWithQuestions:questions];
    if (self) {
        _topTitle = title;
        if ([_topTitle isEqualToString:@"模拟练习"]) {
            _type = ExamPaneTypeBlank;
        } else {
            _type = ExamPaneTypeFull;
        }
    }
    return self;
}

- (EQuestion *)currentQuestion {
    return self.examPane.currentQuestion;
}

+ (instancetype)createWithController:(UIViewController *)controller view:(UIView *)view delegate:(id<EExamPaneControllerDelegate>)delegate title:(NSString *)title questions:(NSArray *)questions {
    EExamPaneController *examVC = [[EExamPaneController alloc] initWithTitle:title questions:questions];
    examVC.delegate = delegate;
    [view addSubview:examVC.view];
    [controller addChildViewController:examVC];
    [examVC didMoveToParentViewController:controller];
    return examVC;
}

- (void)loadView {
    self.view = [[EExamContainer alloc] initWithFrame:_originFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.examPane = [[EExamPane alloc] initWithFrame:self.view.bounds type:_type];
    self.examPane.delegate = self;
    [self.view addSubview:self.examPane];
    
    if (_type == ExamPaneTypeBlank) {
        [self.examPane refreshCheckboxHeartColor:[UIColor blackColor]];
        [self.examPane refreshCheckboxBackgroundColor:RGBCOLOR(238, 208, 113)];
    } else {
        [self.examPane refreshCheckboxHeartColor:RGBCOLOR(159, 219, 137)];
        [self.examPane refreshCheckboxBackgroundColor:RGBCOLOR(159, 219, 137)];
    }
    
    [self refreshTitle:_topTitle];
    [self refreshQuestions:_questions];
    [self refreshQuestion:_questions[0][0] lock:_type == ExamPaneTypeFull];
    
    [self setFullScreen:YES WithAnimation:NO];
    
    if (_type == ExamPaneTypeBlank) {
        [self.examPane refreshCheckboxHeartColor:[UIColor blackColor]];
        [self.examPane refreshCheckboxBackgroundColor:RGBCOLOR(238, 208, 113)];
        self.examPane.totalTimeLbl.text = [NSString stringWithFormat:@"考试时间：%@",[self timeStringWithSeconds:totalTimeInSeconds]];
        _remainTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeRemainTime) userInfo:nil repeats:YES];
        _remainTimeInSeconds = totalTimeInSeconds;
        [_remainTimeTimer fire];
    } else {
        [self.examPane refreshCheckboxHeartColor:RGBCOLOR(159, 219, 137)];
        [self.examPane refreshCheckboxBackgroundColor:RGBCOLOR(159, 219, 137)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count - 2] == self.parentViewController) {
        // push
        self.navigationController.navigationBarHidden = YES;
    } else if ([viewControllers indexOfObject:self.parentViewController] == NSNotFound) {
        // pop
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"考试页面即将释放");
    if (_remainTimeTimer) {
        [_remainTimeTimer invalidate];
        _remainTimeTimer = nil;
    }
}

#pragma mark - EExamPaneDelegate

- (void)backBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller {
    [((EExamContainer *)self.view).containerView addSubview:self.view];
    [self.view.window makeKeyAndVisible];
    
    if (!self.view.window) {
        return;
    }
    
    // 重置设备方向
    [self setFullScreen:NO WithAnimation:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClicked)]) {
        [self.delegate backBtnClicked];
    }
}

- (void)instructionBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller {
    if (!self.view.window) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(instructionBtnClicked)]) {
        [self.delegate instructionBtnClicked];
    }
}

- (void)previousBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller {
    if (!self.view.window) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(previousBtnClicked)]) {
        [self.delegate previousBtnClicked];
    }
}

- (void)nextBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller {
    if (!self.view.window) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextBtnClicked)]) {
        [self.delegate nextBtnClicked];
    }
}

- (void)commitBtnClickedOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller {
    if (!self.view.window) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitBtnClicked)]) {
        [self.delegate commitBtnClicked];
    }
}

- (void)numberBtnClickOnPane:(UIView *)pane controller:(id<EExamPaneDelegate>)controller section:(NSInteger)section row:(NSInteger)row {
    if (!self.view.window) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberBtnClickedAtSection:row:)]) {
        [self.delegate numberBtnClickedAtSection:section row:row];
    }
}

#pragma mark - EAlertWindowDelegate

- (void)eAlertWindow:(EAlertWindow *)alertWindow didClickedAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    } else {
        [self readyForCommit];
    }
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
            strongSelf->_examPane.frame = rect;
        } else {
            [strongSelf rotate:orientation];
            if (strongSelf->_superViewController) {
                [strongSelf->_superViewController addChildViewController:strongSelf];
                [strongSelf didMoveToParentViewController:strongSelf->_superViewController];
                strongSelf->_superViewController = nil;
            }
            strongSelf->_examPane.frame = strongSelf.view.bounds;
            [strongSelf.view addSubview:strongSelf->_examPane];
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
            [strongSelf->_examPane setNeedsLayout];
        }];
    } else {
        rotateTrans();
        [_examPane setNeedsLayout];
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
    _examPane.transform = transform;
    _currentOrientation = orientation;
}

#pragma mark - public methods

- (void)refreshTitle:(NSString *)title {
    [self.examPane refreshTitle:title];
}

- (void)refreshQuestion:(EQuestion *)question lock:(BOOL)lock {
    [self.examPane refreshQuestion:question lock:lock];
}

- (void)refreshQuestions:(NSArray *)questions {
    [self.examPane refreshQuestions:_questions];
}

- (void)previousQuestion {
    NSInteger currentIndex = self.currentQuestion.question_index - 1;
    [self getCurrentSectionAndRowWithIndex:currentIndex];
    [self refreshQuestion:_questions[_currentSection][_currentRow] lock:_type == ExamPaneTypeFull];
}

- (void)nextQuestion {
    NSInteger currentIndex = self.currentQuestion.question_index + 1;
    [self getCurrentSectionAndRowWithIndex:currentIndex];
    [self refreshQuestion:_questions[_currentSection][_currentRow] lock:_type == ExamPaneTypeFull];
}

- (void)commitExam {
    // 小于8.3的时候，不转status bar, 解决8.1 屏幕乱的问题
    if (_isLowIOS) {
        [[UIApplication sharedApplication] setStatusBarOrientation:_orientationWhenFullScreen];
    }
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        strongSelf.examPane.alertWindow.delegate = strongSelf;
        [strongSelf.examPane.alertWindow showWithTitle:@"确认交卷？" cancelTitle:@"取消" confirmTitle:@"确认"];
    });
    if (_isLowIOS) {
        [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
    }
}

- (void)showInstructions {
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf.examPane.instructionWindow show];
    });
}

#pragma mark - other methods

- (void)getCurrentSectionAndRowWithIndex:(NSInteger)index {
    NSInteger firstIndexOfSection = 0;
    for (int i = 0; i < _questions.count; i ++) {
        NSArray *group = _questions[i];
        for (int j = 0; j < group.count; j ++) {
            EQuestion *question = group[j];
            if (j == 0) {
                firstIndexOfSection = question.question_index;
            }
            if (index == question.question_index) {
                _currentSection = i;
                _currentRow = index - firstIndexOfSection;
                break;
            }
        }
    }
}

- (void)changeRemainTime {
    _remainTimeInSeconds --;
    if (_remainTimeInSeconds <= 0) {
        [self readyForCommit];
    }
    self.examPane.remainTimeLbl.text = [NSString stringWithFormat:@"剩余时间：%@",[self timeStringWithSeconds:_remainTimeInSeconds]];
}

/**
 将秒转化为xx小时xx分钟xx秒

 @param timeInSeconds 秒
 @return 转化后的字符串形式
 */
- (NSString *)timeStringWithSeconds:(NSInteger)timeInSeconds {
    if (timeInSeconds > 0 && timeInSeconds < 60) {
        return [NSString stringWithFormat:@"%@秒",@(timeInSeconds)];
    } else if (timeInSeconds >= 60 && timeInSeconds < 3600) {
        NSInteger minutes = timeInSeconds / 60;
        NSInteger seconds = timeInSeconds % 60;
        return [NSString stringWithFormat:@"%@分钟%@秒",@(minutes),@(seconds)];
    } else {
        NSInteger hours = timeInSeconds / 3600;
        NSInteger minutes = timeInSeconds % 3600 / 60;
        NSInteger seconds = timeInSeconds % 3600 % 60;
        return [NSString stringWithFormat:@"%@小时%@分%@秒",@(hours),@(minutes),@(seconds)];
    }
}

/**
 准备交卷
 */
- (void)readyForCommit {
    // 停止计时
    if (_remainTimeTimer) {
        [_remainTimeTimer invalidate];
        _remainTimeTimer = nil;
    }
    // 隐藏弹窗
    [self.examPane.alertWindow hide];
    // 交卷
    EScoreContainController *score = [[EScoreContainController alloc] initWithQuestions:self.questions];
    [self.navigationController pushViewController:score animated:YES];
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
