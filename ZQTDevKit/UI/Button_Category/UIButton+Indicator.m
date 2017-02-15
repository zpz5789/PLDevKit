//
//  UIButton+Indicator.m
//  ZhiQianTong
//
//  Created by zpz on 16/4/19.
//  Copyright © 2016年 zpz. All rights reserved.
//

#import "UIButton+Indicator.h"
#import <objc/runtime.h>

static NSString *const kIndicatorViewKey = @"indicatorView";
static NSString *const kButtonTextObjectKey = @"buttonTextObject";

@implementation UIButton (Indicator)
- (void)showIndicatorAtCenter
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height / 2);
    [indicator startAnimating];
    [self addSubview:indicator];
    
    //设置为normal状态
    NSString *currentButtonTitle = [self titleForState:UIControlStateDisabled];
    self.enabled = NO;
    [self setTitle:currentButtonTitle forState:UIControlStateDisabled];
    
    objc_setAssociatedObject(self, &kButtonTextObjectKey, currentButtonTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showIndicator
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat minTitleX = CGRectGetMinX(self.titleLabel.frame);
    CGFloat minIndicatorX = minTitleX - CGRectGetWidth(indicator.frame) - 5;
    CGFloat centerIndicatorX = (minTitleX - 5 + minIndicatorX)/2;
    CGFloat centerIndecatorY = CGRectGetHeight(self.frame) / 2;
        indicator.center = CGPointMake(centerIndicatorX, centerIndecatorY);
    [indicator startAnimating];
    [self addSubview:indicator];

    //设置为normal状态
    NSString *currentButtonTitle = [self titleForState:UIControlStateDisabled];
    self.enabled = NO;
    [self setTitle:currentButtonTitle forState:UIControlStateDisabled];
    
    objc_setAssociatedObject(self, &kButtonTextObjectKey, currentButtonTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hideIndicator
{
    NSString *currentButtonTitle = (NSString *)objc_getAssociatedObject(self, &kButtonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &kIndicatorViewKey);
    [self setTitle:currentButtonTitle forState:UIControlStateDisabled];
    [indicator removeFromSuperview];
    self.enabled = YES;
}

@end
