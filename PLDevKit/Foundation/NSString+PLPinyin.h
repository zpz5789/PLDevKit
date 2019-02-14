//
//  Created by zpz on 2017/2/15.
//  Copyright © 2017年 zpz. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (PLPinyin)


/**
 eg:wǒ shì zhōng guó rén
 */
- (NSString*)pl_pinyinWithPhoneticSymbol;

/**
 eg:wo shi zhong guo ren
 */
- (NSString*)pl_pinyin;
- (NSArray*)pl_pinyinArray;
- (NSString*)pl_pinyinWithoutBlank;
- (NSArray*)pl_pinyinInitialsArray;
- (NSString*)pl_pinyinInitialsString;

@end
