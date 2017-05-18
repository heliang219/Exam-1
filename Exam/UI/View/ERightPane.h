//
//  ERightPane.h
//  Exam
//
//  Created by yongqingguo on 2017/5/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ERightPaneDelegate <NSObject>

@optional

- (void)rightPaneDidPan;

- (void)toLeft;

- (void)toRight;

@end

/**
 滑动题号面板
 */
@interface ERightPane : UIView

@property (nonatomic,weak) id <ERightPaneDelegate>delegate;

@end
