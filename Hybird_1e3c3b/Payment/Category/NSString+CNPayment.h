//
//  NSString+CNPayment.h
//  HybirdApp
//
//  Created by cean.q on 2018/10/11.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CNPayment)

/// 金额千分位
@property (nonatomic, readonly) NSString *cn_thousandsFormat;

/// 拼上H5域名
@property (nonatomic, readonly) NSString *cn_appendH5Domain;

/// 拼上CDN域名
@property (nonatomic, readonly) NSString *cn_appendCDN;

/// 字符串是否可以转为整数
+ (BOOL)isPureInt:(NSString *)string;

/// 字符串是否可以转为浮点数
+ (BOOL)isPureFloat:(NSString *)string;

/// 将字符串转化为数字
+ (nullable NSNumber *)convertNumber:(NSString *)string;

/// 判断是否是中文
+ (BOOL)isChineseCharacter:(NSString *)string;

/// 拼成银行卡 4位一个空格
+ (NSString *)insertSpaceToString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
