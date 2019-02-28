//
//  PLIAPReceiptLocallyVerifier.m
//  PLDevKit
//
//  Created by zpz on 2019/2/28.
//  Copyright © 2019 Zpz. All rights reserved.
//

#import "PLIAPReceiptLocallyVerifier.h"

NSString *const PLIAPSandboxServer = @"https://sandbox.itunes.apple.com/verifyReceipt";
NSString *const PLIAPLiveServer = @"https://buy.itunes.apple.com/verifyReceipt";


@implementation PLIAPReceiptLocallyVerifier
- (void)verifyTransaction:(SKPaymentTransaction*)transaction
                  success:(void (^)(void))successBlock
                  failure:(void (^)(NSError *error))failureBlock
{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSError *receiptError;
    BOOL isPresent = [receiptURL checkResourceIsReachableAndReturnError:&receiptError];
    if (!isPresent) {
        // No receipt - In App Purchase was never initiated
//        completionHandler(nil, nil);
        return;
    }
    
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    if (!receiptData) {
        // Validation fails
        NSLog(@"Receipt exists but there is no data available. Try refreshing the reciept payload and then checking again.");
//        completionHandler(nil, nil);
        return;
    }
    
    NSError *error;
    NSMutableDictionary *requestContents = [NSMutableDictionary dictionaryWithObject:
                                            [receiptData base64EncodedStringWithOptions:0] forKey:@"receipt-data"];
    if (self.passWord) {
        [requestContents setObject:self.passWord forKey:@"password"];
    }
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    
#ifdef DEBUG
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:PLIAPSandboxServer]];
#else
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:PLIAPLiveServer]];
#endif

    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:storeRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSInteger status = [jsonResponse[@"status"] integerValue];
            NSLog(@"jsonResponse is %@",jsonResponse);
            if (status == 0) {
                // 验证成功
                
                successBlock();
            } else {
                failureBlock(error);
            }
//            if (jsonResponse[@"receipt"] != [NSNull null]) {
//                NSString *originalAppVersion = jsonResponse[@"receipt"][@"original_application_version"];
//                if (nil != originalAppVersion) {
//                    [self.purchaseRecord setObject:originalAppVersion forKey:kOriginalAppVersionKey];
//                    [self savePurchaseRecord];
//                }
//                else {
//                    completionHandler(nil, nil);
//                }
//            }
//            else {
//                completionHandler(nil, nil);
//            }
//
//            if (status != 0) {
//                NSError *error = [NSError errorWithDomain:@"com.mugunthkumar.mkstorekit" code:status
//                                                 userInfo:@{NSLocalizedDescriptionKey : errorDictionary[@(status)]}];
//                completionHandler(nil, error);
//            } else {
//                NSMutableArray *receipts = [jsonResponse[@"latest_receipt_info"] mutableCopy];
//                if (jsonResponse[@"receipt"] != [NSNull null]) {
//                    NSArray *inAppReceipts = jsonResponse[@"receipt"][@"in_app"];
//                    [receipts addObjectsFromArray:inAppReceipts];
//                    completionHandler(receipts, nil);
//                } else {
//                    completionHandler(nil, nil);
//                }
//            }
//        } else {
//            completionHandler(nil, error);
//        }
            
            
            // 比对 jsonResponse 中以下信息基本上可以保证数据安全
            
//             bundle_id
//             application_version
//             product_id
//             transaction_id
            
             
        } else {
            failureBlock(error);
        }
        
    }] resume];
}

@end
