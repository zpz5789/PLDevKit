//
//  UITextField+placeHolder.m
//  SecurityBox
//
//  Created by zpz on 2017/2/20.
//  Copyright © 2017年 zpzDev. All rights reserved.
//

#import "UITextField+placeHolder.h"

@implementation UITextField (placeHolder)
- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    [self setValue:placeholderTextColor forKeyPath:@"_placeholderLabel.textColor"];


}

- (void)setPlaceholderTextFont:(UIFont *)font
{
    [self setValue:font forKeyPath:@"_placeholderLabel.font"];

}
@end
