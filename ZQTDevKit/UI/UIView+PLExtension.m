//
//  UIView+UIView_SBExtension.m
//  SecurityBox
//
//  Created by zpz on 2017/2/21.
//  Copyright © 2017年 zpzDev. All rights reserved.
//

#import "UIView+PLExtension.h"

@implementation UIView (PLExtension)

- (void)setPl_x:(CGFloat)pl_x
{
    CGRect frame = self.frame;
    frame.origin.x = pl_x;
    self.frame = frame;
}

- (void)setPl_y:(CGFloat)pl_y
{
    CGRect frame = self.frame;
    frame.origin.y = pl_y;
    self.frame = frame;
}

- (CGFloat)pl_x
{
    return self.frame.origin.x;
}

- (CGFloat)pl_y
{
    return self.frame.origin.y;
}

- (void)setPl_width:(CGFloat)pl_width
{
    CGRect frame = self.frame;
    frame.size.width = pl_width;
    self.frame = frame;
}

- (void)setPl_height:(CGFloat)pl_height
{
    CGRect frame = self.frame;
    frame.size.height = pl_height;
    self.frame = frame;
}

- (CGFloat)pl_height
{
    return self.frame.size.height;
}

- (CGFloat)pl_width
{
    return self.frame.size.width;
}

- (UIView * (^)(CGFloat x))setX
{
    return ^(CGFloat x) {
        self.pl_x = x;
        return self;
    };
}

- (void)setPl_centerX:(CGFloat)pl_centerX
{
    CGPoint center = self.center;
    center.x = pl_centerX;
    self.center = center;
}

- (CGFloat)pl_centerX
{
    return self.center.x;
}

- (void)setPl_centerY:(CGFloat)pl_centerY
{
    CGPoint center = self.center;
    center.y = pl_centerY;
    self.center = center;
}

- (CGFloat)pl_centerY
{
    return self.center.y;
}

- (void)setPl_size:(CGSize)pl_size
{
    CGRect frame = self.frame;
    frame.size = pl_size;
    self.frame = frame;
}

- (CGSize)pl_size
{
    return self.frame.size;
}

- (void)setPl_origin:(CGPoint)pl_origin
{
    CGRect frame = self.frame;
    frame.origin = pl_origin;
    self.frame = frame;
}

- (CGPoint)pl_origin
{
    return self.frame.origin;
}

- (CGFloat)pl_left {
    return self.frame.origin.x;
}

- (void)setPl_left:(CGFloat)pl_left {
    CGRect frame = self.frame;
    frame.origin.x = pl_left;
    self.frame = frame;
}

- (CGFloat)pl_top {
    return self.frame.origin.y;
}

- (void)setPl_top:(CGFloat)pl_top {
    CGRect frame = self.frame;
    frame.origin.y = pl_top;
    self.frame = frame;
}

- (CGFloat)pl_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setPl_right:(CGFloat)pl_right {
    CGRect frame = self.frame;
    frame.origin.x = pl_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)pl_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setPl_bottom:(CGFloat)pl_bottom {
    CGRect frame = self.frame;
    frame.origin.y = pl_bottom - frame.size.height;
    self.frame = frame;
}


- (UIView *(^)(UIColor *color)) setColor
{
    return ^ (UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (UIView *(^)(CGRect frame)) setFrame
{
    return ^ (CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGSize size)) setSize
{
    return ^ (CGSize size) {
        self.bounds = CGRectMake(0, 0, size.width, size.height);
        return self;
    };
}

- (UIView *(^)(CGPoint point)) setCenter
{
    return ^ (CGPoint point) {
        self.center = point;
        return self;
    };
}


- (void)pl_setLayerBolderWidth:(CGFloat)width bolderColor:(UIColor *)color layerCornerRadius:(CGFloat)radius
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = radius;
}
@end
