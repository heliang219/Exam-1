//
//  EBlockCell.h
//  Exam
//
//  Created by yongqingguo on 2017/1/19.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBlockCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *bgView;
@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UIImageView *indicatorImgView;
@property (nonatomic,strong) UILabel *bottomLine;

/**
 动态改变block尺寸

 @param newSize 改变后的尺寸
 */
- (void)refreshSize:(CGSize)newSize;

- (void)refreshWithTitle:(NSString *)title background:(UIImage *)bgImg;

@end
