//
//  EInstructionWindow.m
//  Exam
//
//  Created by yongqingguo on 2017/1/20.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EInstructionWindow.h"

@implementation EInstructionWindow
{
    UIImageView *_page;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)sharedWindow {
    static EInstructionWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        window = [[EInstructionWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        window.userInteractionEnabled = YES;
    });
    return window;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initHelpPage];
    }
    return self;
}

- (void)initHelpPage {
    _page = [[UIImageView alloc] init];
    _page.userInteractionEnabled = YES;
    _page.image = IMAGE_BY_NAMED(@"help.jpg");
    [self addSubview:_page];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    _page.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}

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
}

@end
