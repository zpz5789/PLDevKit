//
//  UIView+UIView_SBExtension.h
//  SecurityBox
//
//  Created by zpz on 2017/2/21.
//  Copyright © 2017年 zpzDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PLExtension)

/**
 *  1.间隔X值
 */
@property (nonatomic, assign) CGFloat pl_x;

/**
 *  2.间隔Y值
 */
@property (nonatomic, assign) CGFloat pl_y;

/**
 *  3.宽度
 */
@property (nonatomic, assign) CGFloat pl_width;

/**
 *  4.高度
 */
@property (nonatomic, assign) CGFloat pl_height;

/**
 *  5.中心点X值
 */
@property (nonatomic, assign) CGFloat pl_centerX;

/**
 *  6.中心点Y值
 */
@property (nonatomic, assign) CGFloat pl_centerY;

/**
 *  7.尺寸大小
 */
@property (nonatomic, assign) CGSize pl_size;

/**
 *  8.起始点
 */
@property (nonatomic, assign) CGPoint pl_origin;

/**
 *  9.上 < Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat pl_top;

/**
 *  10.下 < Shortcut for frame.origin.y + frame.size.height
 */
@property (nonatomic) CGFloat pl_bottom;

/**
 *  11.左 < Shortcut for frame.origin.x.
 */
@property (nonatomic) CGFloat pl_left;

/**
 *  12.右 < Shortcut for frame.origin.x + frame.size.width
 */
@property (nonatomic) CGFloat pl_right;


/**
 设置view的layer相关属性

 @param width bolderWidth
 @param color bolderColor
 @param cornerRadius CornerRadius
 */
- (void)pl_setLayerBolderWidth:(CGFloat)width bolderColor:(UIColor *)color layerCornerRadius:(CGFloat)cornerRadius;

@end
