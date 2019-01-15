//
//  NSString+MD5.h
//  Hybird_A01
//
//  Created by Domino on 14/01/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MD5)

/**
 *  md5加密的字符串
 *
 *  @param str 需要加密的字符串
 *
 *  @return md5
 */
+ (NSString *)md5:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
