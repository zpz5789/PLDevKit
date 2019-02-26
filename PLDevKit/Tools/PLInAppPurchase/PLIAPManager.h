//
//  PLIAPManager.h
//  PLDevKit
//
//  Created by zpz on 2019/2/26.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

// 日志输出
#ifdef DEBUG
#define PLIAPManagerLog(...) NSLog(__VA_ARGS__)
#else
#define PLIAPManagerLog(...)
#endif


NS_ASSUME_NONNULL_BEGIN

@protocol PLIAPManagerDelegate <NSObject>


@end


@interface PLIAPManager : NSObject


/**
 代理
 */
@property (nonatomic, weak) id <PLIAPManagerDelegate> delegate;


+ (instancetype)sharedManager;


- (void)requestProductsWithProductArray:(NSArray *)products;

/**
 *  传入商品ID购买商品，调起内购服务
 *
 *  @param productID 商品ID
 */
- (void)buyProductWithID:(NSString * _Nonnull)productID;

/**
 恢复购买
 */
- (void)restorePurchase;
@end

NS_ASSUME_NONNULL_END
