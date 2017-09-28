//
//  EUpdateController.m
//  Exam
//
//  Created by yongqingguo on 2017/5/5.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EUpdateController.h"
#import "UINavigationBar+Awesome.h"
#import "EApiClient.h"
#import "NSString+Additions.h"
#import "NSDictionary+Additions.h"
#import "ESubject.h"
#import "EQuestion.h"
#import "EAnswer.h"
#import "EDBHelper.h"

@interface EUpdateController ()
{
    UILabel *_titleLbl;
    UIProgressView *_progressView;
    UILabel *_progressLbl;
    
    NSMutableArray *_subjects;
    NSMutableArray *_questions;
    NSMutableArray *_answers;
    
    NSInteger count;
}

@end

@implementation EUpdateController

- (instancetype)init {
    self = [super init];
    if (self) {
        _subjects = [NSMutableArray array];
        _questions = [NSMutableArray array];
        _answers = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更新";
    [self initContentView];
    
    [self updateSubjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
}

- (void)configNavigationBar {
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame = CGRectMake(0, 0, 24, 24);
    [goBackBtn setImage:IMAGE_BY_NAMED(@"setting_back") forState:UIControlStateNormal];
    [goBackBtn setImage:IMAGE_BY_NAMED(@"setting_back") forState:UIControlStateHighlighted];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
}

- (void)initContentView {
    CGFloat originX = kEPadding * 2;
    CGFloat originY = kNavigationBarHeight + kEPadding * 4;
    
    _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - originX * 2, 20)];
    _titleLbl.text = @"题库更新正在进行，请稍后...";
    _titleLbl.backgroundColor = [UIColor clearColor];
    _titleLbl.textColor = [UIColor blackColor];
    _titleLbl.font = kSmallFont;
    [self.view addSubview:_titleLbl];
    
    originY += _titleLbl.bounds.size.height + kEPadding * 2;
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(originX, originY, kFrameWidth - 70, kEPadding)];
    _progressView.progressTintColor = RGBCOLOR(95, 139, 228);
    _progressView.trackTintColor = RGBCOLOR(184, 190, 196);
    _progressView.progress = 0.f;
    _progressView.progressViewStyle = UIProgressViewStyleDefault;
    [self.view addSubview:_progressView];
    
    originX = kFrameWidth - 60;
    _progressLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 60, 20)];
    _progressLbl.text = @"0%";
    _progressLbl.textAlignment = NSTextAlignmentCenter;
    _progressLbl.backgroundColor = [UIColor clearColor];
    _progressLbl.textColor = RGBCOLOR(95, 139, 228);
    _progressLbl.font = kSmallFont;
    [self.view addSubview:_progressLbl];
    
    // 设置进度条高度
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 3.0);
    _progressView.transform = transform;
    // 设置进度条两端弧度
    _progressView.layer.cornerRadius = 3.f;
    _progressView.layer.masksToBounds = YES;
    
    // 垂直对齐
    _progressLbl.center = CGPointMake(_progressLbl.center.x, _progressView.center.y);
}

- (void)refreshLabel {
    _titleLbl.text = [NSString stringWithFormat:@"已更新%@条数据",@(count)];
}

- (void)refreshProgress:(CGFloat)progress {
    _progressView.progress = progress;
    _progressLbl.text = [NSString stringWithFormat:@"%@%%",@([NSString stringWithFormat:@"%.2f",progress].floatValue * 100)];
}

/**
 更新科目
 */
- (void)updateSubjects {
    NSString *accessToken = [kUserDefaults objectForKey:kAccess_Token];
    NSDate *date = [kUserDefaults objectForKey:kLastUpdateTime_subjects];
    if (!date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; // 实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 设定时间格式,这里可以设置成自己需要的格式
        date = [dateFormat dateFromString:@"2010-01-01 00:00:01"];
        [kUserDefaults setObject:date forKey:kLastUpdateTime_subjects];
        [kUserDefaults synchronize];
    } else {
        [kUserDefaults setObject:[NSDate date] forKey:kLastUpdateTime_subjects];
        [kUserDefaults synchronize];
    }
    
    WEAK
    [[EApiClient sharedClient] updateQuestions:accessToken lastUpdateTime:[NSString stringWithDate:date] updateType:@"subjects" page:1 size:1000 completion:^(id responseObject, NSError *error) {
        STRONG
        strongSelf->_subjects = [NSMutableArray array];
        if (responseObject) {
            NSDictionary *dataDic = [responseObject dictionaryValueForKey:@"data" defaultValue:nil];
            if (dataDic) {
                NSArray *subjectsArr = [dataDic arrayValueForKey:@"subjects" defaultValue:nil];
                if (subjectsArr && subjectsArr.count > 0) {
                    // 更新科目
                    for (NSDictionary *subjectDic in subjectsArr) {
                        NSInteger index = [subjectsArr indexOfObject:subjectDic];
                        NSInteger subject_id = [subjectDic integerValueForKey:@"id" defaultValue:0];
                        NSInteger subject_p_id = [subjectDic integerValueForKey:@"parent_subject_id" defaultValue:0];
                        NSString *subject_title = [subjectDic stringValueForKey:@"title" defaultValue:nil];
                        NSString *update_status = [subjectDic stringValueForKey:@"update_status" defaultValue:nil];
                        ESubject *subject = [[ESubject alloc] init];
                        subject.subject_id = subject_id;
                        subject.subject_p_id = subject_p_id;
                        subject.subject_title = subject_title;
                        [strongSelf->_subjects addObject:subject];
                        if ([update_status isEqualToString:@"new"]) { // 添加
                            [[EDBHelper defaultHelper] insertSubject:subject];
                        } else if ([update_status isEqualToString:@"updated"]) { // 更新
                            [[EDBHelper defaultHelper] updateSubject:subject];
                        } else if ([update_status isEqualToString:@"deleted"]) { // 删除
                            [[EDBHelper defaultHelper] deleteSubject:subject];
                        }
                        count ++;
                        [strongSelf refreshLabel];
                        [strongSelf refreshProgress:(index + 1) / subjectsArr.count * 0.5];
                    }
                    [strongSelf updateQuestions];
                } else {
                    strongSelf->_titleLbl.text = @"已更新！";
                    strongSelf->_progressView.progress = 1.f;
                    strongSelf->_progressLbl.text = @"100%";
                }
            }
        } else {
            [strongSelf showTips:@"更新题库失败" time:1 completion:nil];
        }
    }];
}

/**
 更新题目
 */
- (void)updateQuestions {
    NSString *accessToken = [kUserDefaults objectForKey:kAccess_Token];
    NSDate *date = [kUserDefaults objectForKey:kLastUpdateTime_questions];
    if (!date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; // 实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 设定时间格式,这里可以设置成自己需要的格式
        date = [dateFormat dateFromString:@"2010-01-01 00:00:01"];
        [kUserDefaults setObject:date forKey:kLastUpdateTime_questions];
        [kUserDefaults synchronize];
    } else {
        [kUserDefaults setObject:[NSDate date] forKey:kLastUpdateTime_questions];
        [kUserDefaults synchronize];
    }
    
    WEAK
    [[EApiClient sharedClient] updateQuestions:accessToken lastUpdateTime:[NSString stringWithDate:date] updateType:@"questions" page:1 size:1000 completion:^(id responseObject, NSError *error) {
        STRONG
        strongSelf->_questions = [NSMutableArray array];
        strongSelf->_answers = [NSMutableArray array];
        if (responseObject) {
            NSDictionary *dataDic = [responseObject dictionaryValueForKey:@"data" defaultValue:nil];
            if (dataDic) {
                NSArray *questionsArr = [dataDic arrayValueForKey:@"questions" defaultValue:nil];
                if (questionsArr && questionsArr.count > 0) {
                    // 更新问题
                    for (NSDictionary *questionDic in questionsArr) {
                        NSInteger index = [questionsArr indexOfObject:questionDic];
                        NSInteger question_id = [questionDic integerValueForKey:@"id" defaultValue:0];
                        NSInteger question_subject_id = [questionDic integerValueForKey:@"subject_id" defaultValue:0];
                        NSString *question_content = [questionDic stringValueForKey:@"title" defaultValue:nil];
                        NSString *question_type = [questionDic stringValueForKey:@"question_type" defaultValue:nil];
                        NSInteger question_is_required = [questionDic integerValueForKey:@"is_required" defaultValue:0];
                        NSInteger question_case_id = [questionDic integerValueForKey:@"case_id" defaultValue:0];
                        NSString *update_status = [questionDic stringValueForKey:@"update_status" defaultValue:nil];
                        EQuestion *question = [[EQuestion alloc] init];
                        question.question_id = question_id;
                        question.question_subject_id = question_subject_id;
                        question.question_type = question_type;
                        question.question_content = question_content;
                        question.question_is_required = question_is_required;
                        question.question_case_id = question_case_id;
                        NSArray *answersArr = [questionDic arrayValueForKey:@"question_items" defaultValue:nil];
                        if (answersArr && answersArr.count > 0) {
                            for (NSDictionary *answerDic in answersArr) {
                                EAnswer *answer = [[EAnswer alloc] init];
                                answer.answer_id = [answerDic integerValueForKey:@"id" defaultValue:0];
                                answer.question_id = question_id;
                                answer.answer_content = [answerDic stringValueForKey:@"text" defaultValue:nil];
                                answer.answer_correct = [answerDic boolValueForKey:@"correct" defaultValue:NO];
                                [strongSelf->_answers addObject:answer];
                            }
                        }
                        if ([update_status isEqualToString:@"new"]) { // 添加
                            [[EDBHelper defaultHelper] insertQuestion:question];
                        } else if ([update_status isEqualToString:@"updated"]) { // 更新
                            [[EDBHelper defaultHelper] updateQuestion:question];
                        } else if ([update_status isEqualToString:@"deleted"]) { // 删除
                            [[EDBHelper defaultHelper] deleteQuestion:question];
                        }
                        count ++;
                        [strongSelf refreshLabel];
                        [strongSelf refreshProgress:((index + 1) / questionsArr.count * (questionsArr.count / (questionsArr.count + strongSelf->_answers.count)) * 0.5 + 0.5)];
                    }
                    // 更新答案
                    for (EAnswer *answer in strongSelf->_answers) {
                        NSInteger index = [strongSelf->_answers indexOfObject:answer];
                        [[EDBHelper defaultHelper] insertAnswer:answer];
                        count ++;
                        [strongSelf refreshLabel];
                        [strongSelf refreshProgress:((questionsArr.count / (questionsArr.count + strongSelf->_answers.count)) * 0.5 + 0.5 + (index + 1) / strongSelf->_answers.count)];
                    }
                    strongSelf->_titleLbl.text = @"更新完成！";
                    strongSelf->_progressView.progress = 1.f;
                    strongSelf->_progressLbl.text = @"100%";
                } else {
                    strongSelf->_titleLbl.text = @"更新完成！";
                    strongSelf->_progressView.progress = 1.f;
                    strongSelf->_progressLbl.text = @"100%";
                }
            }
        } else {
            [strongSelf showTips:@"更新题库失败" time:1 completion:nil];
        }
    }];
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
