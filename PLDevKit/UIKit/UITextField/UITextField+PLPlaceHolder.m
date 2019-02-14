//
//  UITextField+placeHolder.m
//  SecurityBox
//
//  Created by zpz on 2017/2/20.
//  Copyright © 2017年 zpzDev. All rights reserved.
//

#import "UITextField+PLPlaceHolder.h"

@implementation UITextField (PLPlaceHolder)
- (void)pl_setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    [self setValue:placeholderTextColor forKeyPath:@"_placeholderLabel.textColor"];


}

- (void)pl_setPlaceholderTextFont:(UIFont *)font
{
    [self setValue:font forKeyPath:@"_placeholderLabel.font"];

}
@end
