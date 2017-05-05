//
//  ESubjectController.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "ESubjectController.h"
#import "EPreparationController.h"
#import "EBlockCell.h"
#import "XLPlainFlowLayout.h"
#import "UIImage+Additions.h"
#import "ESubject.h"
#import "EDBHelper.h"

@interface ESubjectController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_contentArray;
    ESubject *_subject;
}

@end

@implementation ESubjectController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _contentArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithSubject:(ESubject *)subject {
    self = [self init];
    if (self) {
        _subject = subject;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"科目";
    [self initData];
    [self initCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

/**
 初始化数据
 */
- (void)initData {
    _contentArray = [NSMutableArray array];
    [_contentArray addObjectsFromArray:[[EDBHelper defaultHelper] querySubTypes:_subject.subject_id]];
}

- (void)initCollectionView {
    // 创建一个layout布局类
    XLPlainFlowLayout *layout = [[XLPlainFlowLayout alloc] init];
    // 设置导航高度
    layout.naviHeight = 0;
    // 设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 创建collectionView 通过一个布局策略layout来创建
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(kEPadding, kNavigationBarHeight + kEPadding * 2 + kBlockWidth, kFrameWidth - kEPadding * 2, kFrameHeight - (kNavigationBarHeight + kEPadding * 2 + kBlockWidth)) collectionViewLayout:layout];
    collect.backgroundColor = kBackgroundColor;
    collect.showsVerticalScrollIndicator = NO;
    // 代理设置
    collect.delegate = self;
    collect.dataSource = self;
    // 注册item类型 这里使用系统的类型
    [collect registerClass:[EBlockCell class] forCellWithReuseIdentifier:@"EBlockCell"];
    // 注册header
    [collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    // 注册footer
    [collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    
    [self.view addSubview:collect];
}

#pragma mark - collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return _contentArray.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kFrameWidth - kEPadding * 2, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(kFrameWidth - kEPadding * 2, kEPadding);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionReusableView *reusableview = nil;
        
        if (kind == UICollectionElementKindSectionHeader){
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            for (UIView *view in headerView.subviews) {
                [view removeFromSuperview];
            }
            
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height - kEPadding)];
            titleLbl.backgroundColor = [UIColor darkGrayColor];
            titleLbl.textColor = [UIColor whiteColor];
            titleLbl.textAlignment = NSTextAlignmentCenter;
            titleLbl.font = [UIFont boldSystemFontOfSize:20.f];
            
            NSString *title = _subject.subject_title;
            titleLbl.text = title;
            
            headerView.backgroundColor = [UIColor clearColor];
            [headerView addSubview:titleLbl];
            
            reusableview = headerView;
        }
        
        return reusableview;
    } else {
        UICollectionReusableView *reusableview = nil;
        
        if (kind == UICollectionElementKindSectionHeader){
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            for (UIView *view in headerView.subviews) {
                [view removeFromSuperview];
            }
            
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height - kEPadding)];
            titleLbl.backgroundColor = [UIColor darkGrayColor];
            titleLbl.textColor = [UIColor whiteColor];
            titleLbl.textAlignment = NSTextAlignmentCenter;
            titleLbl.font = [UIFont boldSystemFontOfSize:20.f];
            
            NSString *title = @"请选择您的练习科目";
            titleLbl.text = title;
            
            headerView.backgroundColor = [UIColor clearColor];
            [headerView addSubview:titleLbl];
            
            reusableview = headerView;
        } else if (kind == UICollectionElementKindSectionFooter) {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            for (UIView *view in footerView.subviews) {
                [view removeFromSuperview];
            }
            
            footerView.backgroundColor = [UIColor clearColor];
            
            reusableview = footerView;
        }
        
        return reusableview;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(kBlockWidth, kBlockWidth);
    return itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EBlockCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EBlockCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImage *bgImg = nil;
    if (indexPath.row == _contentArray.count) {
        bgImg = [UIImage e_imageWithColor:[UIColor cyanColor]];
        [cell refreshWithTitle:@"返回" background:bgImg];
    } else {
        ESubject *subject = _contentArray[indexPath.row];
        [cell refreshWithTitle:subject.subject_title background:bgImg];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _contentArray.count) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        EPreparationController *subject = [[EPreparationController alloc] initWithSubject:_contentArray[indexPath.row] parentSubject:_subject];
        [self.navigationController pushViewController:subject animated:YES];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
