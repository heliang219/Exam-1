//
//  EBaseController.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+Additions.h"

@interface EBaseController : UIViewController

- (void)configNavigationBar;

/**
 *  返回上一级页面
 */
- (void)goBack;

/**
 弹层提示
 
 @param content 显示的内容
 @param seconds 显示的时间
 */
- (void)showTips:(NSString *)content time:(CGFloat)seconds completion:(void (^)(BOOL finished))completion;

/**
 开始/停止加载
 
 @param loading YES，开始；NO，停止
 */
- (void)startLoading:(BOOL)loading;

@end
