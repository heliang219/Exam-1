//
//  EUtils.m
//  Exam
//
//  Created by yongqingguo on 2017/5/2.
//  Copyright © 2017年 shadeless. All rights reserved.
//

#import "EUtils.h"

@implementation EUtils

+ (void)saveLocalAvator:(UIImage *)image {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *avatorDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Avator"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL directoryExists = [fileManager fileExistsAtPath:avatorDirectory];
    if (!directoryExists) {
        [fileManager createDirectoryAtPath:avatorDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *avatorFilePath = [avatorDirectory stringByAppendingPathComponent:@"avator.png"];
    BOOL fileExists = [fileManager fileExistsAtPath:avatorFilePath];
    if (!fileExists) {
        [fileManager createFileAtPath:avatorFilePath contents:nil attributes:nil];
    }
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:avatorFilePath];
    [fileHandler writeData:UIImageJPEGRepresentation(image, 0.5)];
    [fileHandler closeFile];
}

+ (UIImage *)getLocalAvator {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *avatorDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Avator"];
    NSString *avatorFilePath = [avatorDirectory stringByAppendingPathComponent:@"avator.png"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:avatorFilePath]) {
        NSData *data = [NSData dataWithContentsOfFile:avatorFilePath];
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }
    return nil;
}

+ (BOOL)IsPhoneNumber:(NSString *)number {
    NSString *phoneRegex1 = @"1[34578]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:number];
}

+ (BOOL)IsEmailAdress:(NSString *)Email {
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

+ (BOOL)IsIdentityCard:(NSString *)IDCardNumber {
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

+ (BOOL)IsBankCard:(NSString *)cardNumber {
    if (cardNumber.length == 0) {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++) {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--) {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        } else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

@end
