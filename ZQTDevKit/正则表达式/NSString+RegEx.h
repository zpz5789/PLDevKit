//
//  NSString+RegEx.h
//  ZQTDevKit
//
//  Created by zpz on 2017/2/15.
//  Copyright © 2017年 Zhiqiantong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegEx)
///判断手机号码格式
- (BOOL)isPhoneNumber;

///判断邮箱格式
- (BOOL)isEmailFormat;

///判断QQ号码格式
- (BOOL)isQQNumber;

///判断密码格式
- (BOOL)isPasswordFormat;

///判断中文名称
- (BOOL)isChineseUserName;
@end
