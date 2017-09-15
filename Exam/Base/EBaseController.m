//
//  EBaseController.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBaseController.h"
#import "NSString+Additions.h"

@interface EBaseController ()
{
    void (^completionBlock)(BOOL finished);
    BOOL _stopLoading; // 立即停止加载指令
    NSTimer *_timer;
    NSInteger _nextImage;
}

@property (nonatomic,assign,readwrite) BOOL tipsHidden;
@property (nonatomic,assign,readwrite) BOOL isLoading;

@end

@implementation EBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tipsHidden = YES;
    [self configNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)configNavigationBar {
    // 交给子类去实现
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame = CGRectMake(0, 0, 24, 24);
    [goBackBtn setImage:IMAGE_BY_NAMED(@"back") forState:UIControlStateNormal];
    [goBackBtn setImage:IMAGE_BY_NAMED(@"back") forState:UIControlStateHighlighted];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
}

#pragma mark - UIButtonAction

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)showTips:(NSString *)content time:(CGFloat)seconds completion:(void (^)(BOOL))completion {
    // 已经显示就不重复提示
    if (!self.tipsHidden) {
        return;
    }
    // 要显示的内容为空则不显示
    if (![content realString]) {
        return;
    }
    WEAK
    dispatch_main_async_safe(^{
        STRONG
        UIView *bgView = [[UIView alloc] initWithFrame:URect(0, 0, 220, 100)];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.center = CGPointMake(strongSelf.view.center.x, strongSelf.view.center.y);
        [strongSelf.view addSubview:bgView];
        bgView.layer.cornerRadius = 8.f;
        bgView.layer.masksToBounds = YES;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        contentView.backgroundColor = [UIColor blackColor];
        contentView.alpha = 0.63;
        [bgView addSubview:contentView];
        UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        tipLbl.text = content;
        tipLbl.numberOfLines = 10;
        tipLbl.textColor = [UIColor whiteColor];
        tipLbl.font = UFont(18);
        tipLbl.textAlignment = NSTextAlignmentCenter;
        tipLbl.backgroundColor = [UIColor clearColor];
        [bgView addSubview:tipLbl];
        
        bgView.alpha = 0.f;
        strongSelf.tipsHidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            bgView.alpha = 1.f;
        } completion:^(BOOL finished) {
            dispatch_main_async_safe(^{
                [NSTimer scheduledTimerWithTimeInterval:seconds target:strongSelf selector:@selector(hideTips:) userInfo:@{@"view":bgView} repeats:NO];
            });
        }];
    });
    completionBlock = completion;
}

- (void)hideTips:(NSTimer *)timer {
    UIView *view = (UIView *)timer.userInfo[@"view"];
    WEAK
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 0.f;
    } completion:^(BOOL finished) {
        STRONG
        [view removeFromSuperview];
        strongSelf.tipsHidden = YES;
        if (strongSelf->completionBlock) {
            strongSelf->completionBlock(YES);
        }
    }];
}

- (void)startLoading:(BOOL)loading {
    if (loading) { // 开始加载
        if (_stopLoading) {
            return;
        }
        WEAK
        dispatch_main_async_safe(^{
            STRONG
            UIView *bgView = [strongSelf.view viewWithTag:9999999];
            if (!bgView) {
                bgView = [[UIView alloc] initWithFrame:strongSelf.view.bounds];
                bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
                bgView.tag = 9999999;
                [strongSelf.view addSubview:bgView];
            }
            
            UIImageView *loadingImgView = (UIImageView *)[strongSelf.view viewWithTag:10000000];
            if (!loadingImgView) {
                loadingImgView = [[UIImageView alloc] initWithImage:IMAGE_BY_NAMED(@"loading1_")];
                loadingImgView.userInteractionEnabled = YES;
                loadingImgView.frame = strongSelf.view.bounds;
                loadingImgView.center = strongSelf.view.center;
                loadingImgView.layer.zPosition = 10.f;
                loadingImgView.tag = 10000000;
                [strongSelf.view addSubview:loadingImgView];
                strongSelf->_nextImage = 1;
            }
            loadingImgView.alpha = 0.f;
            strongSelf.isLoading = YES;
            [UIView animateWithDuration:0.1 animations:^{
                loadingImgView.alpha = 1.f;
            } completion:^(BOOL finished) {
                if (!strongSelf->_timer) {
                    strongSelf->_timer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(setNextImage) userInfo:nil repeats:YES];
                }
                [strongSelf->_timer fire];
            }];
        });
    } else { // 停止加载
        _stopLoading = YES;
        WEAK
        dispatch_main_async_safe(^{
            STRONG
            __block UIView *bgView = [strongSelf.view viewWithTag:9999999];
            __block UIImageView *loadingImgView = (UIImageView *)[strongSelf.view viewWithTag:10000000];
            [UIView animateWithDuration:0.2 animations:^{
                bgView.alpha = 0.f;
                loadingImgView.alpha = 0.f;
            } completion:^(BOOL finished) {
                [bgView removeFromSuperview];
                bgView = nil;
                [loadingImgView removeFromSuperview];
                loadingImgView = nil;
                strongSelf.isLoading = NO;
                strongSelf->_stopLoading = NO;
                if (strongSelf->_timer) {
                    [strongSelf->_timer invalidate];
                    strongSelf->_timer = nil;
                }
            }];
        });
    }
}

- (void)setNextImage {
    _nextImage ++;
    if (_nextImage > 15) {
        _nextImage = 1;
    }
    UIImageView *loadingImgView = (UIImageView *)[self.view viewWithTag:10000000];
    NSString *imageName = [NSString stringWithFormat:@"loading%@_",@(_nextImage)];
    loadingImgView.image = IMAGE_BY_NAMED(imageName);
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
