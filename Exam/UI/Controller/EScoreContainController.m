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
@property (nonatomic,strong) NSArray *questions;

@end

@implementation EScoreContainController

- (instancetype)initWithQuestions:(NSArray *)questions {
    self = [super init];
    if (self) {
        _questions = questions;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.scorePaneController = [EScorePaneController createWithController:self view:self.view delegate:self questions:_questions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EScorePaneControllerDelegate

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)correctBtnClicked {
    // 练习复卷
    EExamContainController *exam = [[EExamContainController alloc] initWithTitle:@"练习复卷" questions:self.scorePaneController.questions];
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
