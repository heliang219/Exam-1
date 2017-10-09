//
//  AppDelegate.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) ENavigationController *nav;

- (void)switchToLoginRegisterController;

- (void)switchToNavigationController;

- (void)switchToNavigationControllerWithType:(NSInteger)type;

@end

