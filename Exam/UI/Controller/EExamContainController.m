//
//  EExamContainController.m
//  Exam
//
//  Created by yongqingguo on 2017/1/20.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EExamContainController.h"
#import "EExamPaneController.h"
#import "EQuestion.h"

@interface EExamContainController ()<EExamPaneControllerDelegate>

@property (nonatomic,strong) EExamPaneController *examPaneController;
@property (nonatomic,strong) NSString *topTitle;
@property (nonatomic,strong) NSArray *questions;

@end

@implementation EExamContainController

#pragma mark - Life Cycle

- (instancetype)initWithQuestions:(NSArray *)questions {
    self = [super init];
    if (self) {
        _questions = questions;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title questions:(NSArray *)questions {
    self = [self initWithQuestions:questions];
    if (self) {
        _topTitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.examPaneController = [EExamPaneController createWithController:self view:self.view delegate:self title:_topTitle questions:_questions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - EExamPaneControllerDelegate

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)instructionBtnClicked {
    DLog(@"操作说明");
}

- (void)previousBtnClicked {
    [self.examPaneController previousQuestion];
}

- (void)nextBtnClicked {
    [self.examPaneController nextQuestion];
}

- (void)commitBtnClicked {
    [self.examPaneController commitExam];
}

- (void)numberBtnClickedAtSection:(NSInteger)section row:(NSInteger)row {
    DLog(@"您点击了section : %@,row : %@",@(section),@(row));
    [self.examPaneController refreshQuestion:self.examPaneController.questions[section][row]];
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