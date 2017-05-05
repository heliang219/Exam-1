//
//  UIImage+Additions.h
//  Firecast
//
//  Created by yongqingguo on 16/5/9.
//  Copyright © 2016年 gyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

/**
 *  将图片裁剪到对应的尺寸
 *
 *  @param size 要裁剪的尺寸
 *
 *  @return 返回UIImage对象
 */
- (instancetype)resizeToSize:(CGSize)size;

@end

@interface UIImage (CreateFromColor)

/**
 *  将UIColor转化为UIImage
 *
 *  @param color UIColor对象
 *
 *  @return 返回转换后的UIImage对象
 */
+ (UIImage *)e_imageWithColor:(UIColor *)color;

@end
