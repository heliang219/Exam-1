//
//  NSString+Additions.m
//  Youmina
//
//  Created by yongqingguo on 2017/7/5.
//  Copyright © 2017年 Youmina. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)realString {
    if (!self) {
        return nil;
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0 ? [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : nil;
}

- (NSString *)shortDateString {
    return [[self componentsSeparatedByString:@" "] objectAtIndex:0];
}

- (NSString *)htmlEntityDecodeString {
    // 将特殊字符替换了
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    // 图片自适应
    string = [NSString stringWithFormat:@"<html> \n"
              "<head> \n"
              "<style type=\"text/css\"> \n"
              "</style> \n"
              "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\">"
              
              "</head> \n"
              "<body>"
              "<script type='text/javascript'>"
              "window.onload = function(){\n"
              "var $img = document.getElementsByTagName('img');\n"
              "for(var p in  $img){\n"
              " $img[p].style.width = '100%%';\n"
              "$img[p].style.height ='auto'\n"
              "}\n"
              "}"
              "</script>%@"
              "</body>"
              "</html>",string];
    return string;
}

+ (NSString *)stringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

@end
