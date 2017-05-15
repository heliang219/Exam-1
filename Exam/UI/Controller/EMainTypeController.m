//
//  EMainTypeController.m
//  Exam
//
//  Created by gyq on 2017/1/18.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EMainTypeController.h"
#import "ESubjectController.h"
#import "EBlockCell.h"
#import "XLPlainFlowLayout.h"
#import "EDBHelper.h"
#import "ESubject.h"
#import "ESettingController.h"
#import "UINavigationBar+Awesome.h"

@interface EMainTypeController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_contentArray;
}

@end

@implementation EMainTypeController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _contentArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择工种";
    [self initData];
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNavigationBar {
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 0, 40, 20);
    [settingBtn setImage:IMAGE_BY_NAMED(@"setting") forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
}

- (void)settingAction {
    ESettingController *settingVC = [[ESettingController alloc] init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionMoveIn; // 可更改为其他方式
    transition.subtype = kCATransitionFromTop; // 可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:settingVC animated:NO];
}

/**
 初始化数据
 */
- (void)initData {
    _contentArray = [NSMutableArray array];
    [_contentArray addObjectsFromArray:[[EDBHelper defaultHelper] queryAllTypes]];
}

- (void)initCollectionView {
    // 创建一个layout布局类
    XLPlainFlowLayout *layout = [[XLPlainFlowLayout alloc] init];
    // 设置导航高度
    layout.naviHeight = 0;
    // 设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 创建collectionView 通过一个布局策略layout来创建
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(kEPadding, 0, kFrameWidth - kEPadding * 2, kFrameHeight) collectionViewLayout:layout];
    collect.backgroundColor = [UIColor clearColor];
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
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kFrameWidth - kEPadding * 2, 28);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kFrameWidth - kEPadding * 2, kEPadding);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        
        headerView.backgroundColor = [UIColor clearColor];
        
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(kBlockWidth, kBlockHeight);
    return itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EBlockCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EBlockCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    ESubject *subject = _contentArray[indexPath.row];
    NSString *imageName = [NSString stringWithFormat:@"maintype_%@",@(indexPath.row)];
    UIImage *bgImage = IMAGE_BY_NAMED(imageName);
    [cell refreshWithTitle:subject.subject_title background:bgImage];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ESubjectController *subject = [[ESubjectController alloc] initWithSubject:_contentArray[indexPath.row]];
    [self.navigationController pushViewController:subject animated:YES];
    
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
