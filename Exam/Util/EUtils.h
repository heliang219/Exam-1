//
//  EUtils.h
//  Exam
//
//  Created by yongqingguo on 2017/5/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 工具箱
 */
@interface EUtils : NSObject

+ (NSString *)dataFilePath;

/**
 保存头像图片到本地
 
 @param image 要保存的图片源文件
 */
+ (void)saveLocalAvator:(UIImage *)image;

/**
 从本地读取保存的头像图片
 
 @return 返回头像文件
 */
+ (UIImage *)getLocalAvator;

/**
 手机号格式检查

 @param number 手机号
 @return 是否为正确的手机号
 */
+ (BOOL)IsPhoneNumber:(NSString *)number;

/**
 邮箱格式检查

 @param Email 邮箱
 @return 是否为正确的邮箱号
 */
+ (BOOL)IsEmailAdress:(NSString *)Email;

/**
 身份证格式检查

 @param IDCardNumber 身份证号
 @return 是否为正确的身份证号
 */
+ (BOOL)IsIdentityCard:(NSString *)IDCardNumber;

/**
 银行卡格式检查

 @param cardNumber 银行卡号
 @return 是否为正常的银行卡号
 */
+ (BOOL)IsBankCard:(NSString *)cardNumber;

@end
