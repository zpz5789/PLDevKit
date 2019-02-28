//
//  PLTabOneController.m
//  PLDevKit
//
//  Created by zpz on 2019/2/27.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import "PLTabOneController.h"
#import "PLIAPManager.h"
#import "PLTabOneCell.h"
@interface PLTabOneController ()<PLIAPManagerDelegate, UITableViewDelegate, UITableViewDataSource, PLTabOneCellDelegate>
- (IBAction)getProductClick:(id)sender;
@property (nonatomic, strong) NSArray *products;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *refreshRequest;
- (IBAction)refreshRequest:(id)sender;
@end

@implementation PLTabOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.products = [NSArray array];
    [PLIAPManager sharedManager];
    [PLIAPManager sharedManager].delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.1000000504469442/1000000506120600
}



#pragma PLTabOneCellDelegate
- (void)tabOneCellBuyClick:(SKProduct *)product
{
    [[PLIAPManager sharedManager] addPayment:product.productIdentifier success:^(SKPaymentTransaction *transaction) {
        NSLog(@"交易完成 %@",transaction);
    } failure:^(SKPaymentTransaction *transaction, PLIAPError *error) {
        NSLog(@"交易失败 %@",error.errorMessage);
    }];
}

- (void)tabOneCellRebuyClick:(SKProduct *)product
{
    [[PLIAPManager sharedManager] restoreTransactionsOnSuccess:^(NSArray *transactions) {
        for (SKPaymentTransaction *transaction in transactions) {
            NSLog(@"%@ - %@",product.productIdentifier , transaction.payment.productIdentifier);
            if (product.productIdentifier == transaction.payment.productIdentifier) {
                NSLog(@"购买成功");
            }
        }
    } failure:^(PLIAPError *error) {
        
    }];

}

#pragma mark - PLIAPManagerDelegate
- (void)storeProductsRequestFinished:(NSArray<SKProduct *> *)products invalidProductIDs:(NSArray *)invalidProductIDs
{
//    NSLog(@"%@",products);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    PLTabOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.product = self.products[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma  mark-  Action
- (IBAction)getProductClick:(id)sender {
    NSSet *set = [NSSet setWithObjects:@"test1",@"test4",@"test6",@"xiaohao1",@"zidongxufei1",nil];
    
    [[PLIAPManager sharedManager] requestProducts:set success:^(NSArray<SKProduct *> *products, NSArray *invalidProductIDs) {
        self.products = products;
        NSLog(@"products is %@",products);
        [self.tableView reloadData];
    } failure:^(PLIAPError *error) {
        NSLog(@"%@",error.errorMessage);
    }];
    
    //    [[PLIAPManager sharedManager] requestSKProductsWithProductArray:@[@"test5"]];
    
}
- (IBAction)refreshRequest:(id)sender {
    [[PLIAPManager sharedManager] refreshReceipt];
}
@end
