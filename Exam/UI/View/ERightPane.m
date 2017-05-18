//
//  ERightPane.m
//  Exam
//
//  Created by yongqingguo on 2017/5/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "ERightPane.h"

@implementation ERightPane
{
    CGPoint startPoint; // 触摸起点
    CGPoint startPointInSuperView; // 触摸起点转化为父视图中的左边位置
    BOOL touchesUnAvailable; // 触摸无效
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self];
    if (point.x > 45.f) {
        touchesUnAvailable = YES;
        return;
    }
    touchesUnAvailable = NO;
    startPoint = point;
    startPointInSuperView = [self convertPoint:startPoint toView:self.superview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightPaneDidPan)]) {
        [self.delegate rightPaneDidPan];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touchesUnAvailable) {
        return;
    }
    // 计算位移 = 当前位置 - 起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - startPoint.x;
    
    // 计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y);
    
    
    /* 限制用户不可将视图托出屏幕 */
    float halfx = CGRectGetMidX(self.bounds);
    // x坐标左边界
    newcenter.x = MAX(halfx - 25.f, newcenter.x);
    // x坐标右边界
    newcenter.x = MIN(self.superview.bounds.size.width + halfx - 25.f, newcenter.x);
    
    // 移动view
    self.center = newcenter;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touchesUnAvailable) {
        return;
    }
    CGPoint point = [[touches anyObject] locationInView:self];
    CGPoint newPoint = [self convertPoint:point toView:self.superview];
    if (newPoint.x < startPointInSuperView.x) {
        if (newPoint.x > self.superview.bounds.size.width * 3 / 4.f) {
            [self toRight];
        } else {
            [self toLeft];
        }
    } else {
        if (newPoint.x > self.superview.bounds.size.width / 4.f) {
            [self toRight];
        } else {
            [self toLeft];
        }
    }
}

- (void)toLeft {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toLeft)]) {
        [self.delegate toLeft];
    }
}

- (void)toRight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toRight)]) {
        [self.delegate toRight];
    }
}

@end
