//
//  PLTabOneController.m
//  PLDevKit
//
//  Created by zpz on 2019/2/27.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import "PLTabOneController.h"
#import "PLIAPManager.h"
@interface PLTabOneController ()<PLIAPManagerDelegate>
- (IBAction)buyClick:(id)sender;
- (IBAction)restoreBuyClick:(id)sender;
- (IBAction)getProductClick:(id)sender;
@property (nonatomic, strong) NSArray *products;
@end

@implementation PLTabOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.products = [NSArray array];
    [PLIAPManager sharedManager];
    [PLIAPManager sharedManager].delegate = self;

    // Do any additional setup after loading the view.1000000504469442/1000000506120600
}

- (IBAction)buyClick:(id)sender {
    if (self.products.count) {
        SKProduct *product = [self.products firstObject];
        [[PLIAPManager sharedManager] addPayment:product.productIdentifier success:^(SKPaymentTransaction *transaction) {
            NSLog(@"交易完成 %@",transaction);
        } failure:^(SKPaymentTransaction *transaction, PLIAPError *error) {
            NSLog(@"交易失败 %@",error.errorMessage);
        }];
    }
    
//    [PLIAPManager sharedManager] buyProductWithID:<#(NSString * _Nonnull)#>;
}

- (IBAction)restoreBuyClick:(id)sender {
    if (self.products.count) {
        
    }
}

- (IBAction)getProductClick:(id)sender {
    NSSet *set = [NSSet setWithObjects:@"test1",nil];
    
    [[PLIAPManager sharedManager] requestProducts:set success:^(NSArray<SKProduct *> *products, NSArray *invalidProductIDs) {
        self.products = products;
        NSLog(@"products is %@",products);
    } failure:^(PLIAPError *error) {
        NSLog(@"%@",error.errorMessage);
    }];
//    [[PLIAPManager sharedManager] requestSKProductsWithProductArray:@[@"test5"]];
    
}

#pragma mark - PLIAPManagerDelegate
- (void)storeProductsRequestFinished:(NSArray<SKProduct *> *)products invalidProductIDs:(NSArray *)invalidProductIDs
{
    NSLog(@"%@",products);
}
@end
