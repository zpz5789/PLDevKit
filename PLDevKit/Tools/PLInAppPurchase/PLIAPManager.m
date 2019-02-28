//
//  PLIAPManager.m
//  PLDevKit
//
//  Created by zpz on 2019/2/26.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import "PLIAPManager.h"
#import "PLIAPReceiptLocallyVerifier.h"
// 日志输出
#ifdef DEBUG
#define PLIAPManagerLog(...) NSLog(__VA_ARGS__)
#else
#define PLIAPManagerLog(...)
#endif


@interface PLProductsRequestdelegate : NSObject<SKProductsRequestDelegate>

@property (nonatomic, strong) PLSKProductsRequestSuccessBlock successBlock;
@property (nonatomic, strong) PLSKProductsRequestFailureBlock failureBlock;
@property (nonatomic, weak) PLIAPManager *manager;

@end

@interface PLAddPaymentBlockContainer : NSObject
@property (nonatomic, copy) PLSKAddPaymentSuccessBlock successBlock;
@property (nonatomic, copy) PLSKAddPaymentFailureBlock failureBlock;
@end

@interface PLIAPManager ()<SKPaymentTransactionObserver, SKRequestDelegate>
{
    // 请求产品类数组，用于保存产品请求和回调，可以同时多组请求
    NSMutableSet <PLProductsRequestdelegate *> *_productsRequestDelegates;

    // 保存appStore返回内购产品
    NSMutableDictionary *_allProducts;
    
    // 保存交易请求block
    NSMutableDictionary <NSString *,PLAddPaymentBlockContainer *> *_addPaymentBlockContainers;
    // 刷新收据
    SKReceiptRefreshRequest *_refreshReceiptRequest;
    PLIAPReceiptLocallyVerifier *_defaultReceiptLocallyVerifier;

}
@end

@implementation PLIAPManager

#pragma mark - singleton

+ (instancetype)sharedManager
{
    static PLIAPManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _productsRequestDelegates = [NSMutableSet set];
        _allProducts = [NSMutableDictionary dictionary];
        _addPaymentBlockContainers = [NSMutableDictionary dictionary];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        _defaultReceiptLocallyVerifier = [[PLIAPReceiptLocallyVerifier alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)addProduct:(SKProduct *)product
{
    _allProducts[product.productIdentifier] = product;
}

#pragma mark - requestProduct

- (void)requestProducts:(NSSet *)identifiers
{
    [self requestProducts:identifiers success:nil failure:nil];
}

- (void)requestProducts:(NSSet *)identifiers
                success:(PLSKProductsRequestSuccessBlock)successBlock
                failure:(PLSKProductsRequestFailureBlock)failureBlock
{
    PLIAPError *error = [self verifyPaymentRestrict];
    if (!error) {
        PLProductsRequestdelegate *requestDelegate = [[PLProductsRequestdelegate alloc] init];
        requestDelegate.successBlock = successBlock;
        requestDelegate.failureBlock = failureBlock;
        [_productsRequestDelegates addObject:requestDelegate];
        requestDelegate.manager = self;
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
        productsRequest.delegate = requestDelegate;
        [productsRequest start];
        
    } else {
        failureBlock(error);
    }
}

#pragma mark - addPayment

- (void)addPayment:(NSString *)productIdentifier
{
    [self addPayment:productIdentifier success:nil failure:nil];
}

- (void)addPayment:(NSString *)productIdentifier
           success:(PLSKAddPaymentSuccessBlock)successBlock
           failure:(PLSKAddPaymentFailureBlock)failureBlock
{
    [self addPayment:productIdentifier user:nil success:successBlock failure:failureBlock];
}

- (void)addPayment:(NSString *)productIdentifier
              user:(NSString *)userIdentifier
           success:(PLSKAddPaymentSuccessBlock)successBlock
           failure:(PLSKAddPaymentFailureBlock)failureBlock
{
    PLIAPError *error = [self verifyPaymentRestrict];
    if (!error) {
        SKProduct *product = _allProducts[productIdentifier];
        if (product) {
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            payment.applicationUsername = userIdentifier;
            PLAddPaymentBlockContainer *addPaymentBlockContainer = [[PLAddPaymentBlockContainer alloc] init];
            addPaymentBlockContainer.successBlock = successBlock;
            addPaymentBlockContainer.failureBlock = failureBlock;
            _addPaymentBlockContainers[productIdentifier] = addPaymentBlockContainer;
            // 添加到交易队列
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            
        } else {
            PLIAPManagerLog(@"不能识别的产品ID");
            PLIAPError *error = [[PLIAPError alloc] initWithErrorType:PLIAPPaymentUseUnknownProductID errorMessage:@"不能识别的产品ID"];
            failureBlock(nil, error);
        }
    } else {
        failureBlock(nil, error);
    }
}

- (void)restoreTransactions
{
    [self restoreTransactionsOfUser:nil onSuccess:nil failure:nil];
}

- (void)restoreTransactionsOnSuccess:(PLSKRestoreTransactionsSuccessBlock)successBlock
                             failure:(PLSKRestoreTransactionsFailureBlock)failureBlock
{
    [self restoreTransactionsOfUser:nil onSuccess:successBlock failure:failureBlock];
}

- (void)restoreTransactionsOfUser:(NSString *)userIdentifier
                        onSuccess:(PLSKRestoreTransactionsSuccessBlock)successBlock
                          failure:(PLSKRestoreTransactionsFailureBlock)failureBlock{
    PLIAPError *error = [self verifyPaymentRestrict];
    if (!error) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    } else {
        failureBlock(error);
    }
}

- (void)refreshReceipt
{
    [self refreshReceiptOnSuccess:nil failure:nil];
}

- (void)refreshReceiptOnSuccess:(PLSKRefreshReceiptSuccessBlock)successBlock
                        failure:(PLSKRefreshReceiptFailureBlock)failureBlock
{
    PLIAPError *error = [self verifyPaymentRestrict];
    if (!error) {
        _refreshReceiptRequest = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:@{}];
        _refreshReceiptRequest.delegate = self;
        [_refreshReceiptRequest start];

    } else {
        failureBlock();
    }
}

#pragma mark - SKRequestDelegate
- (void)requestDidFinish:(SKRequest *)request
{
    PLIAPManagerLog(@"requestDidFinish:");
    _refreshReceiptRequest = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    PLIAPManagerLog(@"%@",NSStringFromSelector(_cmd));
    _refreshReceiptRequest = nil;

}

#pragma mark - SKPaymentTransactionObserver
/**
 交易队列更新回调
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing://正在交易
                PLIAPManagerLog(@"正在交易%@",transaction.transactionIdentifier);
                [self didPurchasingTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased://交易完成
                PLIAPManagerLog(@"交易完成%@",transaction.transactionIdentifier);
                [self didPurchaseTransaction:transaction queue:queue];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                PLIAPManagerLog(@"交易失败%@",transaction.transactionIdentifier);
                [self didFailTransaction:transaction queue:queue error:transaction.error];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                PLIAPManagerLog(@"重新购买%@",transaction.transactionIdentifier);
                [self didRestoredTransaction:transaction queue:queue];
                // 恢复购买处理
//                [self restoreTransaction:transaction];
                
                break;
            case SKPaymentTransactionStateDeferred://推迟购买
                PLIAPManagerLog(@"推迟购买");
                [self didDeferTransaction:transaction];
                break;
            default:
                PLIAPManagerLog(@"其他情况");

                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        PLIAPManagerLog(@"移除交易%@",transaction.transactionIdentifier);
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    PLIAPManagerLog(@"恢复购买失败");
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    PLIAPManagerLog(@"重新购买成功");
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads {
    [downloads enumerateObjectsUsingBlock:^(SKDownload *thisDownload, NSUInteger idx, BOOL *stop) {
        SKDownloadState state;
#if TARGET_OS_IPHONE
        state = thisDownload.downloadState;
#elif TARGET_OS_MAC
        state = thisDownload.state;
#endif
        switch (state) {
            case SKDownloadStateActive:
                // Download is actively downloading
                break;
            case SKDownloadStateFinished: {
               // SKDownloadStateFinished 下载完成处理
                [self finishTransaction:thisDownload.transaction queue:queue];
                // 通知下载完成
            }
            case SKDownloadStateFailed: {
                NSError *error = thisDownload.error;
                [self didFailTransaction:thisDownload.transaction queue:queue error:error];
            }
                break;
            default:
                break;
        }
    }];
}


#pragma mark - 处理交易流程
- (void)didPurchaseTransaction:(SKPaymentTransaction *)transaction queue:(SKPaymentQueue*)queue
{
    // 验证收据是否正确
    if (!self.receiptVerifier) {
        self.receiptVerifier = _defaultReceiptLocallyVerifier;
    }
    [self.receiptVerifier verifyTransaction:transaction success:^{
        // 有没有下载项目
        if (transaction.downloads.count > 0) {
            [SKPaymentQueue.defaultQueue startDownloads:transaction.downloads];
        }
        // 保存收据
        
        
        
    } failure:^(NSError *error) {
        [self didFailTransaction:transaction queue:queue error:error];
    }];
    

    [self finishTransaction:transaction queue:queue];
    
}

- (void)didRestoredTransaction:(SKPaymentTransaction *)transaction queue:(SKPaymentQueue*)queue
{
    // 验证收据
    // - 本地验证
    // - appStore验证
    // - 服务器验证
    
   
    // 保存收据
    [self finishTransaction:transaction queue:queue];
}

- (void)didDeferTransaction:(SKPaymentTransaction *)transaction
{
    if ([self.delegate respondsToSelector:@selector(storePaymentTransactionDeferred:)]) {
        [self.delegate storePaymentTransactionDeferred:transaction];
    }
}

- (void)didPurchasingTransaction:(SKPaymentTransaction *)transaction
{
    if ([self.delegate respondsToSelector:@selector(storePaymentTransactionPurchasing)]) {
        [self.delegate storePaymentTransactionPurchasing];
    }
}

- (void)didFailTransaction:(SKPaymentTransaction *)transaction queue:(SKPaymentQueue *)queue error:(NSError *)error
{
    NSString *errorMessage;
    PLIAPErrorType type;
    if(error.code == SKErrorPaymentCancelled) {
        errorMessage = @"用户取消购买";
        type = PLIAPPaymentUserCancel;
    } else {
        errorMessage = @"购买失败，请重试";
        type = PLIAPPaymentFailure;
    }
    
    PLIAPError *plError = [[PLIAPError alloc] initWithErrorType:type errorMessage:errorMessage];
    PLAddPaymentBlockContainer *container = _addPaymentBlockContainers[transaction.transactionIdentifier];
    
    if (container.failureBlock) {
        container.failureBlock(transaction, plError);
    }
    if ([self.delegate respondsToSelector:@selector(storePaymentTransactionFailed:)]) {
        [self.delegate storePaymentTransactionFailed:plError];
    }
    [queue finishTransaction:transaction];
}


- (void)finishTransaction:(SKPaymentTransaction *)transaction queue:(SKPaymentQueue*)queue
{
    PLAddPaymentBlockContainer *container =  _addPaymentBlockContainers[transaction.transactionIdentifier];
    if (container) {
        if (container.successBlock) {
            container.successBlock(transaction);
        }
    }
    [queue finishTransaction:transaction];
}


- (PLIAPError *)verifyPaymentRestrict
{
    if (![self canMakePayments]) {
        PLIAPManagerLog(@"用户没有付款权限");
        PLIAPError *error = [[PLIAPError alloc] initWithErrorType:PLIAPMakePaymentNotAllowed errorMessage:@"用户没有付款权限"];
        return error;
    }
    return nil;
}

- (BOOL)canMakePayments
{
    return [SKPaymentQueue canMakePayments];
}

@end


@interface PLIAPError ()
@property (nonatomic, assign) PLIAPErrorType errorType;
@property (nonatomic, copy) NSString * errorMessage;
@end

@implementation PLIAPError

- (instancetype)initWithErrorType:(PLIAPErrorType)errorType errorMessage:(NSString *)errorMessage
{
    if (self = [super init]) {
        _errorType = errorType;
        _errorMessage = errorMessage;
    }
    return self;
}

@end

@implementation PLProductsRequestdelegate

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    PLIAPManagerLog(@"接收产品响应");
    for (SKProduct *product in response.products) {
        // 保存产品
        [self.manager addProduct:product];
    }
    self.successBlock(response.products, response.invalidProductIdentifiers);
    if ([self.manager.delegate respondsToSelector:@selector(storeProductsRequestFinished:invalidProductIDs:)]) {
        [self.manager.delegate storeProductsRequestFinished:response.products invalidProductIDs:response.invalidProductIdentifiers];
    }
}

@end

@implementation PLAddPaymentBlockContainer

@end
