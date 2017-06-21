//
//  UITextField+placeHolder.h
//  SecurityBox
//
//  Created by zpz on 2017/2/20.
//  Copyright © 2017年 zpzDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (placeHolder)

/**
 设置输入框占位文字颜色

 @param placeholderTextColor 颜色
 */
- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor;


/**
 设置输入框占位文字字体

 @param font 字体
 */
- (void)setPlaceholderTextFont:(UIFont *)font;

@end
