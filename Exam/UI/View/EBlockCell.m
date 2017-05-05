//
//  EBlockCell.m
//  Exam
//
//  Created by yongqingguo on 2017/1/19.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBlockCell.h"

@interface EBlockCell()

@property (nonatomic,assign) CGSize refreshedSize;

@end

@implementation EBlockCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kBlockWidth, kBlockWidth)];
        _bgView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_bgView];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kBlockWidth, kBlockWidth)];
        _titleLbl.numberOfLines = 3;
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = kSmallFont;
        [self.contentView addSubview:_titleLbl];
        
        if (_refreshedSize.width > 0 && _refreshedSize.height > 0) {
            _bgView.frame = CGRectMake(0, 0, _refreshedSize.width, _refreshedSize.height);
            _titleLbl.frame = CGRectMake(0, 0, _refreshedSize.width, _refreshedSize.height);
        }
    }
    return self;
}

- (void)refreshSize:(CGSize)newSize {
    _refreshedSize = CGSizeMake(newSize.width, newSize.height);
    _bgView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
    _titleLbl.frame = CGRectMake(0, 0, newSize.width, newSize.height);
}

- (void)refreshWithTitle:(NSString *)title background:(UIImage *)bgImg {
    _titleLbl.text = title;
    if (bgImg) {
        _bgView.image = bgImg;
    } else {
        _bgView.image = nil;
    }
}

@end
