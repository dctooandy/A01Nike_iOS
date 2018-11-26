//
//  CNPaymentModel.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPaymentModel.h"

@implementation CNPaymentModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"isAvailable": @"status"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"paymentType"]) {
        return YES;
    }
    return NO;
}

- (NSString<Ignore> *)paymentTitle {
    switch (self.paymentType) {
            
        case CNPaymentOnline:
            return @"在线支付";
        case CNPaymentCard:
            return @"点卡支付";
        case CNPaymentDeposit:
            return @"手工存款";
        case CNPaymentBTC:
            return @"比特币支付";
        case CNPaymentWechatBarCode:
            return @"微信条码";
        case CNPaymentWechatApp:
            return @"微信支付";
        case CNPaymentAliApp:
            return @"支付宝支付";
        case CNPaymentQQApp:
            return @"QQ钱包";
        case CNPaymentUnionApp:
            return @"银联支付";
        case CNPaymentWechatQR:
            return @"微信扫码";
        case CNPaymentAliQR:
            return @"支付宝扫码";
        case CNPaymentQQQR:
            return @"QQ扫码";
        case CNPaymentUnionQR:
            return @"银联扫码";
        case CNPaymentJDQR:
            return @"京东扫码";
        case CNPaymentBQFast:
            return @"快速支付";
        case CNPaymentBQWechat:
            return @"微信转账";
        case CNPaymentBQAli:
            return @"支付宝转账";
    }
}

- (NSArray<NSNumber *> *)prePayAmountArray {
    
    switch (self.paymentType) {
            
        case CNPaymentWechatApp:
        case CNPaymentWechatQR:
        case CNPaymentAliApp:
        case CNPaymentAliQR:
        case CNPaymentQQApp:
        case CNPaymentQQQR:
        case CNPaymentUnionApp:
        case CNPaymentUnionQR:
        case CNPaymentJDQR:
        case CNPaymentCard:
        case CNPaymentWechatBarCode:
            return @[@(100), @(1000), @(2000), @(3000), @(5000)];
            break;
        case CNPaymentOnline:
            return @[@(100), @(1000), @(5000), @(10000), @(20000)];
            break;
        case CNPaymentBQFast:
        case CNPaymentBQWechat:
        case CNPaymentBQAli:
            return @[@(1000), @(10000), @(50000), @(500000), @(1000000)];
            break;
        case CNPaymentDeposit:
        case CNPaymentBTC:
            return @[@(100), @(1000), @(10000), @(50000), @(150000)];
            break;
    }
}


- (NSArray<NSString *> *)payTypeArray {
    switch (self.paymentType) {
        case CNPaymentAliQR:
        case CNPaymentQQApp:
        case CNPaymentQQQR:
        case CNPaymentUnionApp:
        case CNPaymentUnionQR:
            return @[@"支付宝扫码", @"微信扫码", @"QQ扫码", @"银联扫码", @"京东扫码"];
        case CNPaymentDeposit:
            return @[@"柜台传账", @"ATM现金转账", @"ATM跨行转账", @"网银转账",
                     @"电话转账", @"跨行网银转账", @"手机转账", @"支付宝转账",
                     @"微信转账", @"跨行手机转账", @"其他方式"];
        default:
            return @[];
    }
}

@end
