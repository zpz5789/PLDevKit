//
//  Created by zpz on 2017/2/15.
//  Copyright © 2017年 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (PLAddition)
/**
 *  @brief  暂停NSTimer
 */
- (void)pl_pauseTimer;
/**
 *  @brief  开始NSTimer
 */
- (void)pl_resumeTimer;
/**
 *  @brief  延迟开始NSTimer
 */
- (void)pl_resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
