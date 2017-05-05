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

@end
