//
//  EBlockCell.m
//  Exam
//
//  Created by yongqingguo on 2017/1/19.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EBlockCell.h"

#define indicatorWidth 24.f
#define indicatorRightMargin 12.f

@interface EBlockCell()

@property (nonatomic,assign) CGSize refreshedSize;

@end

@implementation EBlockCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kBlockWidth, kBlockHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 2.f;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(kEPadding, 0, kBlockWidth - kEPadding * 2, kBlockHeight)];
        _titleLbl.numberOfLines = 3;
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = kSmallFont;
        [self.contentView addSubview:_titleLbl];
        
        _bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(kEPadding, kBlockHeight - 1, kBlockWidth - kEPadding, 1)];
        _bottomLine.backgroundColor = HEXCOLOR(0xdfe3e9);
        [self.contentView addSubview:_bottomLine];
        _bottomLine.hidden = YES;
        
        _indicatorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kBlockWidth - (indicatorWidth + indicatorRightMargin), (kBlockHeight - indicatorWidth) / 2.f, indicatorWidth, indicatorWidth)];
        _indicatorImgView.image = IMAGE_BY_NAMED(@"indicator");
        [self.contentView addSubview:_indicatorImgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_refreshedSize.width > 0 && _refreshedSize.height > 0) {
        _bgView.frame = CGRectMake(0, 0, _refreshedSize.width, _refreshedSize.height);
        if (_titleLbl.text) {
            CGFloat mintextWidth = 100.f;
            if (mintextWidth < _refreshedSize.width) {
                _titleLbl.frame = CGRectMake(kEPadding, 0, _refreshedSize.width - kEPadding * 2, _refreshedSize.height);
            } else {
                _titleLbl.frame = CGRectMake(0, 0, _refreshedSize.width, _refreshedSize.height);
            }
        }
        _bottomLine.frame = CGRectMake(kEPadding, _refreshedSize.height - 1, _refreshedSize.width - kEPadding, 1);
        _indicatorImgView.frame = CGRectMake(_refreshedSize.width - (indicatorWidth + indicatorRightMargin), (_refreshedSize.height - indicatorWidth) / 2.f, indicatorWidth, indicatorWidth);
    } else {
        _bgView.frame = CGRectMake(0, 0, kBlockWidth, kBlockHeight);
        _titleLbl.frame = CGRectMake(kEPadding, 0, kBlockWidth - kEPadding * 2, kBlockHeight);
        _bottomLine.frame = CGRectMake(kEPadding, kBlockHeight - 1, kBlockWidth - kEPadding, 1);
        _indicatorImgView.frame = CGRectMake(kBlockWidth - (indicatorWidth + indicatorRightMargin), (kBlockHeight - indicatorWidth) / 2.f, indicatorWidth, indicatorWidth);
    }
}

- (void)refreshSize:(CGSize)newSize {
    _refreshedSize = CGSizeMake(newSize.width, newSize.height);
    [self setNeedsLayout];
}

- (void)refreshWithTitle:(NSString *)title background:(UIImage *)bgImg {
    _titleLbl.text = title;
    if (bgImg) {
        _bgView.image = bgImg;
    } else {
        _bgView.image = nil;
    }
    [self setNeedsLayout];
}

@end
