//
//  EPreparationController.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EPreparationController.h"
#import "EExerciseListController.h"
#import "EExamContainController.h"
#import "XLPlainFlowLayout.h"
#import "EBlockCell.h"
#import "ESubject.h"
#import "EDBHelper.h"

#define blockWidth (kFrameWidth - kEPadding * 3) / 2.f

@interface EPreparationController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    ESubject *_pSubject;
    ESubject *_subject;
}

@end

@implementation EPreparationController

#pragma mark - Life Cycle

- (instancetype)initWithSubject:(ESubject *)subject parentSubject:(ESubject *)pSubject {
    self = [super init];
    if (self) {
        _pSubject = pSubject;
        _subject = subject;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考试准备";
    [self initCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - init

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
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kFrameWidth - kEPadding * 2, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(kFrameWidth - kEPadding * 2, 50);
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
            
            NSString *title = _pSubject.subject_title;
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
            
            NSString *title = _subject.subject_title;
            titleLbl.text = title;
            
            headerView.backgroundColor = [UIColor clearColor];
            [headerView addSubview:titleLbl];
            
            reusableview = headerView;
        } else if (kind == UICollectionElementKindSectionFooter) {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            for (UIView *view in footerView.subviews) {
                [view removeFromSuperview];
            }
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor cyanColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
            [btn setTitle:@"返回选择科目" forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, kEPadding, footerView.bounds.size.width, footerView.bounds.size.height - kEPadding);
            [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            
            footerView.backgroundColor = [UIColor clearColor];
            [footerView addSubview:btn];
            
            reusableview = footerView;
        }
        
        return reusableview;
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(blockWidth, blockWidth);
    return itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EBlockCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EBlockCell" forIndexPath:indexPath];
    [cell refreshSize:CGSizeMake(blockWidth, blockWidth)];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        [cell refreshWithTitle:@"开始练习" background:nil];
    } else {
        [cell refreshWithTitle:@"查看试题" background:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 开始练习
        NSArray *questions = [[EDBHelper defaultHelper] queryQuestions:_subject.subject_id];
        EExamContainController *exam = [[EExamContainController alloc] initWithQuestions:questions];
        [self.navigationController pushViewController:exam animated:YES];
    } else {
        // 查看试题
        EExerciseListController *exercise = [[EExerciseListController alloc] initWithSubject:_subject];
        [self.navigationController pushViewController:exercise animated:YES];
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
