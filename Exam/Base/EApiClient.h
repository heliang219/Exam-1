//
//  EApiClient.h
//  Exam
//
//  Created by yongqingguo on 2017/9/14.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "AFHTTPSessionManager.h"

// 请求响应状态
typedef NS_ENUM(NSInteger,EApiStatus) {
    EApiStatusOK = 1, // 请求成功
};

typedef void (^EApiRequestCompletionBlock) (id responseObject,NSError *error);

@interface EApiClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (instancetype)onlineClient;

#pragma mark - 对外接口

- (NSString *)baseUrl;

// 用户注册
- (void)userRegister:(NSString *)name
         certificate:(NSString *)certificate
               phone:(NSString *)phone
          completion:(EApiRequestCompletionBlock)completion;

// 发送短信验证码
- (void)sendSMSCode:(NSString *)phone
         completion:(EApiRequestCompletionBlock)completion;

// 登录
- (void)login:(NSString *)phone
 validateCode:(NSString *)validateCode
   completion:(EApiRequestCompletionBlock)completion;

// 上传身份证照片imageType传“certificate_image_back”，头像传“avatar”
- (void)uploadPicture:(NSInteger)userId
            imageType:(NSString *)imageType
            imageData:(NSString *)base64ImageData
          accessToken:(NSString *)accessToken
           completion:(EApiRequestCompletionBlock)completion;

// 获取用户信息
- (void)getUserInfo:(NSInteger)userId
        accessToken:(NSString *)accessToken
         completion:(EApiRequestCompletionBlock)completion;

// 请求激活
- (void)requestActivation:(NSInteger)userId
              accessToken:(NSString *)accessToken
               completion:(EApiRequestCompletionBlock)completion;

// 选择科目
- (void)selectSubjectsOrNot:(NSInteger)userId
                accessToken:(NSString *)accessToken
                 subjectIds:(NSArray *)subjectIds
                removeOrNot:(BOOL)removeOrNot
                 completion:(EApiRequestCompletionBlock)completion;

// 获取最新版本
- (void)getLatestVersion:(NSString *)client
          currentVersion:(NSString *)currentVersion
              completion:(EApiRequestCompletionBlock)completion;

// 更新题库，先 update_type=subjects 新种类，然后再 questions 新具体的题
- (void)updateQuestions:(NSString *)accessToken
         lastUpdateTime:(NSString *)lastUpdateTime
             updateType:(NSString *)updateType // subjects for subject update, questions for questions update
                   page:(NSInteger)page // default to 1, index from 1
                   size:(NSInteger)size // default to 100, maximum 1000
             completion:(EApiRequestCompletionBlock)completion;

// 交卷
- (void)examCommit:(NSString *)accessToken
         startTime:(NSString *)startTime
           endTime:(NSString *)endTime
totalQuestionCount:(NSInteger)totalQuestionCount
correctQuestionCount:(NSInteger)correctQuestionCount
            isPass:(BOOL)isPass
  questionResponse:(NSArray *)questionResponse
        completion:(EApiRequestCompletionBlock)completion;

@end
