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
