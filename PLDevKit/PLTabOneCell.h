//
//  PLTabOneCell.h
//  PLDevKit
//
//  Created by zpz on 2019/2/28.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol PLTabOneCellDelegate <NSObject>

- (void)tabOneCellBuyClick:(SKProduct *)product;
- (void)tabOneCellRebuyClick:(SKProduct *)product;
@end
@interface PLTabOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) SKProduct *product;
@property (nonatomic, weak) id<PLTabOneCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
