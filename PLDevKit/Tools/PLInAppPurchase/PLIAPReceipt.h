//
//  PLIAPReceipt.h
//  PLDevKit
//
//  Created by zpz on 2019/2/28.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLIAPReceipt : NSObject
- (instancetype)initWithASN1Data:(NSData*)asn1Data NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
