//
//  NSString+Additions.h
//  Youmina
//
//  Created by yongqingguo on 2017/7/5.
//  Copyright © 2017年 Youmina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

/**
 去两头空格

 @return 返回去掉首尾空格后的字符串
 */
- (NSString *)realString;

- (NSString *)shortDateString;

- (NSString *)htmlEntityDecodeString;

/**
 将日期转化成字符串格式
 
 @param date 日期
 @return 转化后的字符串格式
 */
+ (NSString *)stringWithDate:(NSDate *)date;

@end
