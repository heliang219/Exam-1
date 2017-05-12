//
//  EMacro.h
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#ifndef EMacro_h
#define EMacro_h

// 系统版本
#define kSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

// 语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

// 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 主题颜色
#define kThemeColor RGBACOLOR(241, 209, 101, 1.0)

// 背景颜色（赭石）
#define kBackgroundColor [UIColor whiteColor]

// 控件之间的间隔
#define kEPadding 10.f

// 屏幕尺寸
#define kFrameWidth [UIScreen mainScreen].bounds.size.width
#define kFrameHeight [UIScreen mainScreen].bounds.size.height

// 导航栏高度
#define kNavigationBarHeight 64.f

// 图片
#define IMAGENAME(Value) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(Value, nil) ofType:nil]]
#define IMAGE_BY_NAMED(value) [UIImage imageNamed:NSLocalizedString((value), nil)]

// 字体
#define kBigFont [UIFont systemFontOfSize:21.f]      // 大号字体
#define kMediumFont [UIFont systemFontOfSize:18.f]  // 中等字体
#define kSmallFont [UIFont systemFontOfSize:15.f]    // 小号字体
#define kTinyFont [UIFont systemFontOfSize:12.f]    // 微小字体

#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define kNumberOfBlocksPerRow 3 // 每行的block数量
#define kBlockWidth (kFrameWidth - kEPadding * (kNumberOfBlocksPerRow + 1)) / kNumberOfBlocksPerRow  // 方块block的size
#define kHeaderViewHeight kBlockWidth + kEPadding * 2 + kNavigationBarHeight // 头部视图高度（从导航栏顶部开始）

#endif /* EMacro_h */
