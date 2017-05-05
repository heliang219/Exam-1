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

@interface EScorePaneController ()<EScorePaneDelegate>

@property (nonatomic,assign) BOOL fullScreen;  // 是否是全屏
@property (nonatomic,assign) UIInterfaceOrientation currentOrientation; // 当前的方向
@property (nonatomic,assign) UIInterfaceOrientation orientation;
@property (nonatomic,assign) BOOL statusbarHidden;  // 状态条是否隐藏
@property (nonatomic,assign) UIInterfaceOrientation orientationWhenFullScreen; // 记住全屏时画面的方向，用来决定弹框方向，<8.3的bug
@property (nonatomic,assign) BOOL isLowIOS; // iOS版本是否小于8.3
@property (nonatomic,weak) UIViewController *superViewController;
@property (nonatomic,strong) EScorePane *scorePane;
@property (nonatomic,assign) CGRect originFrame;  // 初始化尺寸
@property (nonatomic,strong,readwrite) NSArray *questions;  // 所有试题

@end

@implementation EScorePaneController

#pragma mark - Life Cycle

- (instancetype)initWithQuestions:(NSArray *)questions {
    self = [super init];
    if (self) {
        _questions = questions;
        _isLowIOS = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 8.4f) {
            _isLowIOS = YES;
        }
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _originFrame.size = CGSizeMake(MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height));
    }
    return self;
}

- (void)loadView {
    self.view = [[EExamContainer alloc] initWithFrame:_originFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scorePane = [[EScorePane alloc] initWithFrame:self.view.bounds];
    self.scorePane.delegate = self;
    [self.view addSubview:self.scorePane];
    
    [self refreshScore:@"10" rate:@"10%"];
    
    [self setFullScreen:YES WithAnimation:NO];
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
}

- (void)dealloc {
    DLog(@"EScorePaneController即将释放");
}

+ (instancetype)createWithController:(UIViewController *)controller view:(UIView *)view delegate:(id<EScorePaneControllerDelegate>)delegate questions:(NSArray *)questions {
    EScorePaneController *scoreVC = [[EScorePaneController alloc] initWithQuestions:questions];
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
        _orientation = [[UIApplication sharedApplication] statusBarOrientation];
        _statusbarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
        UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            orientation = (UIInterfaceOrientation)deviceOrientation;
        } else {
            orientation = UIInterfaceOrientationLandscapeRight;
        }
        _orientationWhenFullScreen = orientation;
    } else {
        orientation = _orientation;
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

- (void)correctBtnClickedOnPane:(UIView *)pane controller:(id<EScorePaneDelegate>)controller {
    if (self.delegate && [self.delegate respondsToSelector:@selector(correctBtnClicked)]) {
        [self.delegate correctBtnClicked];
    }
}

#pragma mark - public methods

- (void)refreshScore:(NSString *)score rate:(NSString *)rate {
    [self.scorePane refreshScore:score rate:rate];
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
