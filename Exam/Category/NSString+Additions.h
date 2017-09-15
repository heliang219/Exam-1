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

@end
