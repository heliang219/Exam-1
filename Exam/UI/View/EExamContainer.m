//
//  EExamContainer.m
//  Exam
//
//  Created by yongqingguo on 2017/1/20.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EExamContainer.h"

@implementation EExamContainer

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
        self.autoresizesSubviews = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview && !_containerView) {
        _containerView = newSuperview;
    } else if (!newSuperview) {
        _containerView = nil;
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

@end
