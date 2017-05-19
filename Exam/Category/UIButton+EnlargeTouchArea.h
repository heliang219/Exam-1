//
//  UIButton+EnlargeTouchArea.h
//  svpsdk
//
//  Created by yongqingguo on 16/6/21.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  扩大按钮大可点击区域
 */
@interface UIButton (EnlargeTouchArea)

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
