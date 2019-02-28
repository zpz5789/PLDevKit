//
//  PLIAPReceiptLocallyVerifier.h
//  PLDevKit
//
//  Created by zpz on 2019/2/28.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLIAPManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface PLIAPReceiptLocallyVerifier : NSObject <PLIAPManagerReceiptVerifier>
// Only used for receipts that contain auto-renewable subscriptions. Your app’s shared secret (a hexadecimal string).

@property (nonatomic, strong) NSString *passWord;

@end

NS_ASSUME_NONNULL_END
