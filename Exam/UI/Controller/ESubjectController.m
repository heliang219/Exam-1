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
#import "UINavigationBar+Awesome.h"
#import "EApiClient.h"
#import "EUtils.h"

#define blockWidth kFrameWidth
#define blockHeight 70.f / 667.f * kFrameHeight

@interface ESubjectController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_contentArray;
    ESubject *_subject;
    ESubjectType _type;
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

- (instancetype)initWithSubject:(ESubject *)subject type:(ESubjectType)type {
    self = [self initWithSubject:subject];
    if (self) {
        _type = type;
    }
    return self;
}

- (instancetype)initWithContentArray:(NSMutableArray *)contentArray type:(ESubjectType)type {
    self = [self init];
    if (self) {
        if (contentArray && contentArray.count > 0) {
            _contentArray = contentArray;
        }
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    self.title = _subject.subject_title;
    if (!_contentArray || _contentArray.count == 0) {
        [self loadData];
    }
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _type = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

/**
 初始化数据
 */
- (void)loadData {
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
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) collectionViewLayout:layout];
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(blockWidth, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
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
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == _contentArray.count - 1) {
        cell.bottomLine.hidden = YES;
    } else {
        cell.bottomLine.hidden = NO;
    }
    [cell refreshSize:CGSizeMake(blockWidth, blockHeight)];
    UIImage *bgImg = nil;
    ESubject *subject = _contentArray[indexPath.row];
    NSString *filePath = [EUtils dataFilePath];
    NSMutableArray *subjects = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        subjects = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    if (_type == ESubjectTypeSelection) {
        if (subjects && subjects.count > 0) { // 已选择了科目
            cell.contentView.alpha = 0.2f;
            cell.contentView.userInteractionEnabled = NO;
            for (NSNumber *sub_id in subjects) {
                if ([sub_id integerValue] == subject.subject_id) {
                    cell.contentView.alpha = 1.f;
                    cell.contentView.userInteractionEnabled = YES;
                    break;
                }
            }
        }
    } else {
        cell.contentView.alpha = 1.f;
        cell.contentView.userInteractionEnabled = YES;
    }
    [cell refreshWithTitle:subject.subject_title background:bgImg];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (cell.contentView.alpha < 1.f) {
        return;
    }
    // 选择科目
    if ([kUserDefaults boolForKey:kIsChoosing]) {
        ESubject *subject = _contentArray[indexPath.row];
        NSString *filePath = [EUtils dataFilePath];
        NSArray *selectedNumbers = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            selectedNumbers = [[NSArray alloc] initWithContentsOfFile:filePath];
        }
        if (!selectedNumbers) { // 第一次选择
            NSArray *numbers = @[@(subject.subject_id)];
            [numbers writeToFile:filePath atomically:YES];
            WEAK
            [self showTips:@"请再选择一门科目" time:1 completion:^(BOOL finished){
                STRONG
                [strongSelf.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeSelectSubjectsNotification object:nil];
            }];
        } else { // 第二次选择
            NSMutableArray *muArr = [NSMutableArray arrayWithArray:selectedNumbers];
            [muArr addObject:@(subject.subject_id)];
            [muArr writeToFile:filePath atomically:YES];
            
            NSInteger userId = [kUserDefaults integerForKey:kUserId];
            NSString *accessToken = [kUserDefaults objectForKey:kAccess_Token];
            WEAK
            [[EApiClient sharedClient] selectSubjectsOrNot:userId accessToken:accessToken subjectIds:muArr removeOrNot:NO completion:^(id responseObject, NSError *error) {
                STRONG
                [kUserDefaults setBool:NO forKey:kIsChoosing];
                if (responseObject) {
                    [strongSelf showTips:@"科目选择成功" time:1 completion:^(BOOL finished){
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kDeSelectSubjectsNotification object:nil];
                    }];
                } else {
                    [strongSelf showTips:@"科目选择失败" time:1 completion:^(BOOL finished){
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kDeSelectSubjectsNotification object:nil];
                    }];
                    DLog(@"error : %@",error.localizedDescription);
                }
            }];
        }
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
