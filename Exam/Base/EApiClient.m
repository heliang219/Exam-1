//
//  EApiClient.m
//  Exam
//
//  Created by yongqingguo on 2017/9/14.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EApiClient.h"

#define EApiClientBaseURLString @"http://unieagle.net:4000"

#define USER_REGISTER @"/api/users/signup.json" // 用户注册
#define SEND_SMS_CODE @"/api/users/send_verification_code.json" // 发送手机验证码
#define USER_LOGIN @"/api/users/signin.json" // 用户登录
#define UPLOAD_PICTURE @"/api/users/6/upload_image.json" // 用户身份证图片上传
#define GET_USER_INFO @"/api/users/6.json" // 获取用户信息
#define USER_ACTIVATE @"/api/users/6/request_activation.json" // 用户请求激活
#define SELECT_SUBJECT_OR_NOT @"/api/users/6/select_subjects.json" // 用户选择或者取消选择科目
#define CHECK_VERSION @"/api/check_version.json" // 客户端最新版本检查
#define UPDATE_QUESTIONS @"/api/questions/update_questions" // 更新题库
#define EXAM_COMMIT @"/api/exam" // 考试交卷

@implementation EApiClient

+ (instancetype)sharedClient {
    static EApiClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[EApiClient alloc] initWithBaseURL:[NSURL URLWithString:EApiClientBaseURLString]];
        sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置请求超时时间（直接设置无效）
        [sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [sharedClient.requestSerializer setTimeoutInterval:30];
        [sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        // 设置请求头
        // 设置响应头
        sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/xml",@"image/jpeg",@"text/html", nil];
    });
    
    return sharedClient;
}

+ (instancetype)onlineClient {
    static EApiClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[EApiClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://121.41.117.167:3000"]];
        sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置请求超时时间（直接设置无效）
        [sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [sharedClient.requestSerializer setTimeoutInterval:30];
        [sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        // 设置请求头
        // 设置响应头
        sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/xml",@"image/jpeg",@"text/html", nil];
    });
    
    return sharedClient;
}

/* 封装get请求 */
- (void)getAsyncWithShortUrl:(NSString *)shortUrl params:(id)params completion:(EApiRequestCompletionBlock)completion {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 启动状态栏网络请求指示
    [self GET:shortUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@ responseObject : %@",shortUrl,responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态来网络请求指示
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            responseObject = jsonDict;
        }
        if ([responseObject objectForKey:@"error"]) {
            if (completion) {
                completion([NSError errorWithDomain:NSOSStatusErrorDomain code:-1 userInfo:@{@"error":[responseObject objectForKey:@"error"]}],nil);
            }
        } else {
            if (completion) {
                completion(responseObject,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@ error : %@",shortUrl,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态来网络请求指示
        if (completion) {
            completion(nil,error);
        }
    }];
}

/* 封装post请求 */
- (void)postAsyncWithShortUrl:(NSString *)shortUrl params:(id)params completion:(EApiRequestCompletionBlock)completion {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 启动状态栏网络请求指示
    [self POST:shortUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@ responseObject : %@",shortUrl,responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态来网络请求指示
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            responseObject = jsonDict;
        }
        if ([responseObject objectForKey:@"error"]) {
            if (completion) {
                completion([NSError errorWithDomain:NSOSStatusErrorDomain code:-1 userInfo:@{@"error":[responseObject objectForKey:@"error"]}],nil);
            }
        } else {
            if (completion) {
                completion(responseObject,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@ error : %@",shortUrl,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态来网络请求指示
        if (completion) {
            completion(nil,error);
        }
    }];
}

#pragma mark - 对外接口

- (NSString *)baseUrl {
    return EApiClientBaseURLString;
}

- (void)userRegister:(NSString *)name
         certificate:(NSString *)certificate
               phone:(NSString *)phone
          completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *param = @{@"name":name,@"certificate":certificate,@"phone":phone};
    NSDictionary *params = @{@"user":param};
    [self postAsyncWithShortUrl:USER_REGISTER params:params completion:completion];
}

- (void)sendSMSCode:(NSString *)phone
         completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *params = @{@"phone":phone};
    [self postAsyncWithShortUrl:SEND_SMS_CODE params:params completion:completion];
}

- (void)login:(NSString *)phone
 validateCode:(NSString *)validateCode
   completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *params = @{@"phone":phone,@"verification_code":validateCode};
    [self postAsyncWithShortUrl:USER_LOGIN params:params completion:completion];
}

// 上传身份证照片imageType传“certificate_image_back”，头像传“avatar”
- (void)uploadPicture:(NSInteger)userId
            imageType:(NSString *)imageType
            imageData:(NSString *)base64ImageData
          accessToken:(NSString *)accessToken
           completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *params = @{@"access_token":accessToken,@"image_type":imageType,@"image_data":base64ImageData};
    [self postAsyncWithShortUrl:[UPLOAD_PICTURE stringByReplacingOccurrencesOfString:@"6" withString:[NSString stringWithFormat:@"%@",@(userId)]] params:params completion:completion];
}

- (void)getUserInfo:(NSInteger)userId
        accessToken:(NSString *)accessToken
         completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *params = @{@"access_token":accessToken};
    [self getAsyncWithShortUrl:[GET_USER_INFO stringByReplacingOccurrencesOfString:@"6" withString:[NSString stringWithFormat:@"%@",@(userId)]] params:params completion:completion];
}

- (void)requestActivation:(NSInteger)userId
              accessToken:(NSString *)accessToken
               completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *params = @{@"access_token":accessToken};
    [self postAsyncWithShortUrl:[USER_ACTIVATE stringByReplacingOccurrencesOfString:@"6" withString:[NSString stringWithFormat:@"%@",@(userId)]] params:params completion:completion];
}

- (void)selectSubjectsOrNot:(NSInteger)userId
                accessToken:(NSString *)accessToken
                 subjectIds:(NSArray *)subjectIds
                removeOrNot:(BOOL)removeOrNot
                 completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *param = @{@"access_token":accessToken,@"subjects":subjectIds};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    if (removeOrNot) {
        params[@"remove"] = @(YES);
    }
    [self postAsyncWithShortUrl:[SELECT_SUBJECT_OR_NOT stringByReplacingOccurrencesOfString:@"6" withString:[NSString stringWithFormat:@"%@",@(userId)]] params:params completion:completion];
}

- (void)getLatestVersion:(NSString *)client
          currentVersion:(NSString *)currentVersion
              completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *params = @{@"client":@"ios",@"current_version":currentVersion};
    [self getAsyncWithShortUrl:CHECK_VERSION params:params completion:completion];
}

- (void)updateQuestions:(NSString *)accessToken
         lastUpdateTime:(NSString *)lastUpdateTime
             updateType:(NSString *)updateType
                   page:(NSInteger)page
                   size:(NSInteger)size
             completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *params = @{@"access_token":accessToken,@"last_updated_at":lastUpdateTime,@"update_type":updateType,@"page":@(page),@"page_size":@(size)};
    [self postAsyncWithShortUrl:UPDATE_QUESTIONS params:params completion:completion];
}

// 交卷
- (void)examCommit:(NSString *)accessToken
         startTime:(NSString *)startTime
           endTime:(NSString *)endTime
totalQuestionCount:(NSInteger)totalQuestionCount
correctQuestionCount:(NSInteger)correctQuestionCount
            isPass:(BOOL)isPass
  questionResponse:(NSArray *)questionResponse
        completion:(EApiRequestCompletionBlock)completion {
    NSDictionary *params = @{@"token":accessToken,@"started_at":startTime,@"end_at":endTime,@"total_question_count":@(totalQuestionCount),@"correct_question_count":@(correctQuestionCount),@"passed":@(isPass),@"question_responses":questionResponse};
    [self postAsyncWithShortUrl:EXAM_COMMIT params:params completion:completion];
}

@end
