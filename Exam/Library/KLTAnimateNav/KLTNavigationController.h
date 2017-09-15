//
//  CZNavigationController.h
//  ChongZu
//
//  Created by cz10000 on 16/4/27.
//  Copyright © 2016年 cz10000. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLTNavigationController : UINavigationController

@property(strong,nonatomic) UIPanGestureRecognizer *panGestureRec;

- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController;
- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController;

@end
