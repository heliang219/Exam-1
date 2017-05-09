//
//  EExerciseListController.m
//  Exam
//
//  Created by gyq on 2017/1/19.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EExerciseListController.h"
#import "XLPlainFlowLayout.h"
#import "EBlockCell.h"
#import "ESubject.h"
#import "EDBHelper.h"
#import "EExamContainController.h"

@interface EExerciseListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_contentArray;
    ESubject *_subject;
}

@end

@implementation EExerciseListController

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
    self.title = @"习题列表";
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
    [_contentArray addObjectsFromArray:[[EDBHelper defaultHelper] queryQuestions:_subject.subject_id]];
}

- (void)initCollectionView {
    // 创建一个layout布局类
    XLPlainFlowLayout *layout = [[XLPlainFlowLayout alloc] init];
    // 设置导航高度
    layout.naviHeight = kNavigationBarHeight;
    // 设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 创建collectionView 通过一个布局策略layout来创建
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(kEPadding, 0, kFrameWidth - kEPadding * 2, kFrameHeight) collectionViewLayout:layout];
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    for (NSArray *arr in _contentArray) {
        count += arr.count;
    }
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kFrameWidth - kEPadding * 2, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kFrameWidth - kEPadding * 2, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kEPadding, headerView.bounds.size.width, headerView.bounds.size.height - kEPadding * 2)];
        titleLbl.backgroundColor = [UIColor darkGrayColor];
        titleLbl.textColor = [UIColor whiteColor];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.font = [UIFont boldSystemFontOfSize:20.f];
        
        NSString *title = _subject.subject_title;
        titleLbl.text = title;
        
        headerView.backgroundColor = [UIColor whiteColor];
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
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, kEPadding, footerView.bounds.size.width, footerView.bounds.size.height - kEPadding * 2);
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:btn];
        
        reusableview = footerView;
    }
    
    return reusableview;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(kBlockWidth, kBlockWidth);
    return itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EBlockCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EBlockCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [cell refreshWithTitle:[NSString stringWithFormat:@"习题%@",@(indexPath.row + 1)] background:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 查看试题
    EExamContainController *exam = [[EExamContainController alloc] initWithTitle:@"查看试题" questions:_contentArray orientationWanted:UIInterfaceOrientationPortrait];
    EQuestion *question = nil;
    NSInteger totalCount = 0;
    for (NSInteger i = 0; i < _contentArray.count; i ++) {
        NSArray *arr = _contentArray[i];
        totalCount += arr.count;
        if (indexPath.row < totalCount) {
            NSInteger lastTotalCount = totalCount - arr.count;
            question = arr[indexPath.row - lastTotalCount];
            break;
        }
    }
    [exam refreshQuestion:question];
    [self.navigationController pushToController:exam animated:YES];
    
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
