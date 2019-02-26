//
//  PLIAPManager.m
//  PLDevKit
//
//  Created by zpz on 2019/2/26.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import "PLIAPManager.h"

dispatch_queue_t pl_iap_queue(){
    static dispatch_queue_t pl_iap_queue;
    static dispatch_once_t onceToken_iap_queue;
    dispatch_once(&onceToken_iap_queue, ^{
        pl_iap_queue = dispatch_queue_create("com.iap.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return pl_iap_queue;
}

@interface PLIAPManager ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (nonatomic, assign) BOOL ifOnceRequestFinished; //判断一次请求是否完成

@property (nonatomic, strong) NSMutableDictionary *productDict;

@end

@implementation PLIAPManager

static PLIAPManager *_instance;

#pragma mark - singleton
+ (instancetype)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance start];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (void)start
{
    // Observers are not retained.  The transactions array will only be synchronized with the server while the queue has observers.  This may require that the user authenticate.
    // 添加监听者监听内购交易状态
    dispatch_async(pl_iap_queue(), ^{
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    });
}

#pragma mark - SKPaymentTransactionObserver

/**
 交易状态更新回调
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchasing://正在交易
                
                break;
                
            case SKPaymentTransactionStatePurchased://交易完成
                
//                [self getReceipt]; //获取交易成功后的购买凭证
//
//                [self saveReceipt]; //存储交易凭证
//
//                [self checkIAPFiles];//把self.receipt发送到服务器验证是否有效
//
//                [self completeTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateFailed://交易失败
                // 交易失败处理
//                [self failedTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                // 恢复购买处理
//                [self restoreTransaction:transaction];
                
                break;
                
            default:
                
                break;
        }
    }
    
}

#pragma mark - SKProductsRequestDelegate

/**
 请求内购产品回调
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    if (products.count == 0) {
        NSLog(@"无法获取产品信息，请重试");
//        [self filedWithErrorCode:IAP_FILEDCOED_CANNOTGETINFORMATION error:nil];
        self.ifOnceRequestFinished = YES; //失败，请求完成
    } else {
        for (SKProduct *product in products) {
            // 保存产品
            [self.productDict setObject:product forKey:product.productIdentifier];
        }
        // 产品信息获取成功回调
        //    [self.delegate IAPToolGotProducts:productArray];
    }
}

#pragma mark -
/**
 *  根据用户传入的数组（包装的产品id）询问苹果的服务器上的产品
 *
 *  @param products 商品ID的数组
 */
- (void)requestProductsWithProductArray:(NSArray * _Nonnull)products
{
    PLIAPManagerLog(@"请求可销售商品列表");
    if (!_ifOnceRequestFinished) {
        if ([SKPaymentQueue canMakePayments]) {
            // 能够销售的商品
            NSSet *set = [[NSSet alloc] initWithArray:products];
            // "异步"询问苹果能否销售
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
            request.delegate = self;
            [request start];
        } else {
            PLIAPManagerLog(@"不允许内购，没有权限");
            _ifOnceRequestFinished = YES; //完成请求
        }
    } else {
        PLIAPManagerLog(@"交易正在进行，请稍定");
    }
}


/**
 *  询问苹果的服务器能够销售哪些商品
 *
 *  @param productID 商品ID的数组
 */

- (void)requestProductWithProductID:(NSString * _Nonnull)productID
{
    PLIAPManagerLog(@"请求可销售商品列表");
    if (!_ifOnceRequestFinished) {
        if ([SKPaymentQueue canMakePayments]) {
            // 能够销售的商品
            NSSet *set = [[NSSet alloc] initWithObjects:productID, nil];
            // "异步"询问苹果能否销售
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
            request.delegate = self;
            [request start];
        } else {
            PLIAPManagerLog(@"不允许内购，没有权限");
            _ifOnceRequestFinished = YES; //完成请求
        }
    } else {
        PLIAPManagerLog(@"交易正在进行，请稍定");
    }

}

- (void)buyProductWithID:(NSString * _Nonnull)productID
{
    SKProduct *product = self.productDict[productID];
    
    // 要购买产品(店员给用户开了个小票)
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    // 去收银台排队，准备购买(异步网络)
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - 懒加载

- (NSMutableDictionary *)productDict
{
    if (!_productDict) {
        _productDict = [NSMutableDictionary dictionary];
    }
    return _productDict;
}



@end
