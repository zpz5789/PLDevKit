//
//  PLTabOneCell.m
//  PLDevKit
//
//  Created by zpz on 2019/2/28.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import "PLTabOneCell.h"
@interface PLTabOneCell ()
- (IBAction)purchaseClick:(id)sender;
- (IBAction)rePurchaseClick:(id)sender;

@end
@implementation PLTabOneCell

- (void)setProduct:(SKProduct *)product
{
    _product = product;
    self.nameLabel.text = product.productIdentifier;
    self.priceLabel.text = [self localizedPriceOfProduct:product];
}

- (NSString*)localizedPriceOfProduct:(SKProduct*)product
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.locale = product.priceLocale;
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    return formattedString;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)purchaseClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tabOneCellBuyClick:)]) {
        [self.delegate tabOneCellBuyClick:self.product];
    }
}

- (IBAction)rePurchaseClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tabOneCellRebuyClick:)]) {
        [self.delegate tabOneCellRebuyClick:self.product];
    }
}
@end
