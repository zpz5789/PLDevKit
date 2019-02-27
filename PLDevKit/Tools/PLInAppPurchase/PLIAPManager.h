//
//  PLIAPManager.h
//  PLDevKit
//
//  Created by zpz on 2019/2/26.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


typedef NS_ENUM(NSUInteger, PLIAPErrorType) {
    PLIAPMakePaymentNotAllowed,// 没有付款权限
    PLIAPPaymentUseUnknownProductID,// 未知产品ID
    PLIAPPaymentUserCancel,//用户取消
    PLIAPPaymentFailure,//购买失败
};

@interface PLIAPError : NSObject
@property (nonatomic, assign, readonly) PLIAPErrorType errorType;
@property (nonatomic, copy, readonly) NSString * errorMessage;

- (instancetype)initWithErrorType:(PLIAPErrorType)errorType errorMessage:(NSString *)errorMessage;
@end


/// 请求内购产品成功block
typedef void (^PLSKProductsRequestSuccessBlock)(NSArray <SKProduct *> * products, NSArray *invalidProductIDs);
typedef void (^PLSKProductsRequestFailureBlock)(PLIAPError *error);

/// 购买成功
typedef void (^PLSKAddPaymentSuccessBlock)(SKPaymentTransaction *transaction);
typedef void (^PLSKAddPaymentFailureBlock)(SKPaymentTransaction *transaction, PLIAPError *error);

/// 恢复购买 void (^)(NSArray *transactions)
typedef void (^PLSKRestoreTransactionsSuccessBlock)(NSArray *transactions);
typedef void (^PLSKRestoreTransactionsFailureBlock)(PLIAPError *);

/// 刷新收据 refreshReceipt
typedef void (^PLSKRefreshReceiptSuccessBlock)(void);
typedef void (^PLSKRefreshReceiptFailureBlock)(void);


@protocol PLIAPManagerDelegate <NSObject>

- (void)storePaymentTransactionDeferred:(SKPaymentTransaction *)transaction;
- (void)storePaymentTransactionFailed:(PLIAPError *)error;
- (void)storePaymentTransactionPurchasing;
- (void)storePaymentTransactionDidFinished:(SKPaymentTransaction *)transaction;
- (void)storeProductsRequestDidFailed:(NSError *)error;
- (void)storeProductsRequestFinished:(NSArray <SKProduct *> * )products invalidProductIDs:(NSArray *) invalidProductIDs;
- (void)storeRefreshReceiptFailed:(PLIAPError *)error;
- (void)storeRefreshReceiptFinished:(NSArray <SKProduct *> * )products invalidProductIDs:(NSArray *) invalidProductIDs;
- (void)storeRestoreTransactionsFailed:(PLIAPError *)error;
- (void)storeRestoreTransactionsFinished:(SKPaymentTransaction *)transaction;
@end


@interface PLIAPManager : NSObject

@property (nonatomic, weak) id <PLIAPManagerDelegate> delegate;

+ (instancetype)sharedManager;
+ (instancetype)alloc __attribute__((unavailable("call sharedManager instead")));
+ (instancetype)new __attribute__((unavailable("call sharedManager instead")));
- (instancetype)copy __attribute__((unavailable("call sharedManager instead")));
- (instancetype)mutableCopy __attribute__((unavailable("call sharedManager instead")));

// 通过IDs获取产品
- (void)requestProducts:(NSSet *)identifiers;

- (void)requestProducts:(NSSet *)identifiers
                success:(PLSKProductsRequestSuccessBlock)successBlock
                failure:(PLSKProductsRequestFailureBlock)failureBlock;

- (void)addPayment:(NSString *)productIdentifier;

- (void)addPayment:(NSString *)productIdentifier
           success:(PLSKAddPaymentSuccessBlock)successBlock
           failure:(PLSKAddPaymentFailureBlock)failureBlock;

- (void)addPayment:(NSString *)productIdentifier
              user:(NSString *)userIdentifier
           success:(PLSKAddPaymentSuccessBlock)successBlock
           failure:(PLSKAddPaymentFailureBlock)failureBlock;

- (void)restoreTransactions;

- (void)restoreTransactionsOnSuccess:(PLSKRestoreTransactionsSuccessBlock)successBlock
                             failure:(PLSKRestoreTransactionsFailureBlock)failureBlock;

- (void)restoreTransactionsOfUser:(NSString *)userIdentifier
                        onSuccess:(PLSKRestoreTransactionsSuccessBlock)successBlock
                          failure:(PLSKRestoreTransactionsFailureBlock)failureBlock;

- (void)refreshReceipt;

- (void)refreshReceiptOnSuccess:(PLSKRefreshReceiptSuccessBlock)successBlock
                        failure:(PLSKRefreshReceiptFailureBlock)failureBlock;

@end


