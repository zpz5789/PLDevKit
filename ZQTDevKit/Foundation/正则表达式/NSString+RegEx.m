//
//  NSString+RegEx.m
//  ZQTDevKit
//
//  Created by zpz on 2017/2/15.
//  Copyright © 2017年 Zhiqiantong. All rights reserved.
//

#import "NSString+RegEx.h"

@implementation NSString (RegEx)
///判断手机号码格式
- (BOOL)isPhoneNumber
{
    NSString *regExStr = @"^1[3|4|5|7|8][0-9]{9}$";
    return [self verifyWithRegExStr:regExStr];
}

///判断邮箱格式
- (BOOL)isEmailFormat
{
    NSString *regExStr = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    return [self verifyWithRegExStr:regExStr];
}

///判断QQ号码格式
- (BOOL)isQQNumber
{
    NSString *regExStr = @"^[1-9]\\d{4-11}$";
    return [self verifyWithRegExStr:regExStr];
}

///判断密码格式
- (BOOL)isPasswordFormat
{
    //次数是6-12位密码
    NSString *regExStr = @"^[A-Za-z0-9]{6,12}$";
    return [self verifyWithRegExStr:regExStr];
}

///判断中文名称
- (BOOL)isChineseUserName
{
    NSString *regExStr = @"(^[\u4e00-\u9fa5]{0,}$)";
    return  [self verifyWithRegExStr:regExStr];
}

///检测有效身份证
//15位
- (BOOL) isValidIdentifyFifteen
{
    NSString * identifyTest=@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    return [self verifyWithRegExStr:identifyTest];
}
//18位
- (BOOL) isValidIdentifyEighteen
{
    NSString * identifyTest=@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    return [self verifyWithRegExStr:identifyTest];
}




///限制只能输入数字
- (BOOL) isOnlyNumber
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < self.length) {
        NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    
    return res;
}




- (BOOL)verifyWithRegExStr:(NSString *)regEx
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [predicate evaluateWithObject:self];
}

@end
