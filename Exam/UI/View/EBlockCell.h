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

- (void)refreshSize:(CGSize)newSize;

- (void)refreshWithTitle:(NSString *)title background:(UIImage *)bgImg;

@end
