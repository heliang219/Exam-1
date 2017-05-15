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

#define blockWidth kFrameWidth
#define blockHeight 54.f / 667.f * kFrameHeight

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
    self.title = _subject.subject_title;
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
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) collectionViewLayout:layout];
    collect.backgroundColor = [UIColor clearColor];
    collect.showsVerticalScrollIndicator = NO;
    // 代理设置
    collect.delegate = self;
    collect.dataSource = self;
    // 注册item类型 这里使用系统的类型
    [collect registerClass:[EBlockCell class] forCellWithReuseIdentifier:@"EBlockCell"];
    
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(blockWidth, blockHeight);
    return itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EBlockCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EBlockCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == _contentArray.count - 1) {
        cell.bottomLine.hidden = YES;
    } else {
        cell.bottomLine.hidden = NO;
    }
    [cell refreshSize:CGSizeMake(blockWidth, blockHeight)];
    [cell refreshWithTitle:[NSString stringWithFormat:@"习题%@",@(indexPath.row + 1)] background:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 查看题目
    EExamContainController *exam = [[EExamContainController alloc] initWithTitle:@"查看题目" questions:_contentArray orientationWanted:UIInterfaceOrientationPortrait];
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
    [exam refreshQuestion:question lock:YES];
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
