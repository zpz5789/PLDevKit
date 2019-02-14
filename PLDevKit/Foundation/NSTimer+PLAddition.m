//
//  Created by zpz on 2017/2/15.
//  Copyright © 2017年 zpz. All rights reserved.
//

#import "NSTimer+PLAddition.h"

@implementation NSTimer (PLAddition)
/**
 *  @brief  暂停NSTimer
 */
-(void)pl_pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}
/**
 *  @brief  开始NSTimer
 */
-(void)pl_resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}
/**
 *  @brief  延迟开始NSTimer
 */
- (void)pl_resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}
@end
