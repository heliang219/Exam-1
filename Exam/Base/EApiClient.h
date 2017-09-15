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

#pragma mark - 对外接口

- (NSString *)baseUrl;

- (void)userRegister:(NSString *)name
         certificate:(NSString *)certificate
               phone:(NSString *)phone
          completion:(EApiRequestCompletionBlock)completion;

- (void)sendSMSCode:(NSString *)phone
         completion:(EApiRequestCompletionBlock)completion;

- (void)login:(NSString *)phone
 validateCode:(NSString *)validateCode
   completion:(EApiRequestCompletionBlock)completion;

// 上传身份证照片imageType传“certificate_image_back”，头像传“avatar”
- (void)uploadPicture:(NSInteger)userId
            imageType:(NSString *)imageType
            imageData:(NSString *)base64ImageData
          accessToken:(NSString *)accessToken
           completion:(EApiRequestCompletionBlock)completion;

- (void)getUserInfo:(NSInteger)userId
        accessToken:(NSString *)accessToken
         completion:(EApiRequestCompletionBlock)completion;

- (void)requestActivation:(NSInteger)userId
              accessToken:(NSString *)accessToken
               completion:(EApiRequestCompletionBlock)completion;

- (void)selectSubjectsOrNot:(NSInteger)userId
                accessToken:(NSString *)accessToken
                 subjectIds:(NSArray *)subjectIds
                removeOrNot:(BOOL)removeOrNot
                 completion:(EApiRequestCompletionBlock)completion;

@end
