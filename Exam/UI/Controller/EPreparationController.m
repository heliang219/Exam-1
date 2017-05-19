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
#import "UINavigationBar+Awesome.h"

#define blockWidth 282.f / 350.f * kFrameWidth
#define blockHeight 62.f / 667.f * kFrameHeight

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
    self.view.backgroundColor = kBackgroundColor;
    self.title = _subject.subject_title;
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self.view addSubview:collect];
}

#pragma mark - collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kFrameWidth - kEPadding * 2, 30);
    } else {
        return CGSizeMake(kFrameWidth - kEPadding * 2, 24);
    }
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
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(blockWidth, blockHeight);
    return itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EBlockCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EBlockCell" forIndexPath:indexPath];
    [cell refreshSize:CGSizeMake(blockWidth, blockHeight)];
    cell.contentView.layer.cornerRadius = blockHeight / 2.f;
    cell.contentView.layer.borderColor = [UIColor blackColor].CGColor;
    cell.contentView.layer.borderWidth = 1.f;
    cell.contentView.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLbl.textAlignment = NSTextAlignmentCenter;
    cell.indicatorImgView.hidden = YES;
    if (indexPath.section == 0) {
        [cell refreshWithTitle:@"开始练习" background:nil];
    } else {
        [cell refreshWithTitle:@"查看习题" background:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 开始练习
        NSArray *questions = [[EDBHelper defaultHelper] queryQuestions:_subject.subject_id];
        EExamContainController *exam = [[EExamContainController alloc] initWithTitle:@"模拟练习" questions:questions orientationWanted:UIInterfaceOrientationPortrait];
        [self.navigationController pushViewController:exam animated:YES];
    } else {
        // 查看习题
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
