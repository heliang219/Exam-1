//
//  EScoreContainController.m
//  Exam
//
//  Created by yongqingguo on 2017/2/4.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EScoreContainController.h"
#import "EScorePaneController.h"
#import "EExamContainController.h"


@interface EScoreContainController ()<EScorePaneControllerDelegate>

@property (nonatomic,strong) EScorePaneController *scorePaneController;
@property (nonatomic,copy) NSString *topTitle;
@property (nonatomic,strong) NSArray *questions;
@property (nonatomic,strong) EExam *exam;

@end

@implementation EScoreContainController

- (instancetype)initWithTitle:(NSString *)title questions:(NSArray *)questions exam:(EExam *)exam {
    self = [super init];
    if (self) {
        _topTitle = title;
        _questions = questions;
        _exam = exam;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.scorePaneController = [EScorePaneController createWithController:self view:self.view delegate:self title:_topTitle questions:_questions exam:_exam];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EScorePaneControllerDelegate

- (void)backBtnClicked {
    [self.scorePaneController goBack];
}

- (void)bottomBtnClicked {
    // 练习复卷
    EExamContainController *exam = [[EExamContainController alloc] initWithTitle:@"练习复卷" questions:self.scorePaneController.questions orientationWanted:UIInterfaceOrientationLandscapeRight];
    [self.navigationController pushViewController:exam animated:YES];
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
