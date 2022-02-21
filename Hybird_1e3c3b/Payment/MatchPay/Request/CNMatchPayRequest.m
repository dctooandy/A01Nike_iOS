//
//  CNMatchPayRequest.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/19/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMatchPayRequest.h"

@implementation CNMatchPayRequest
+ (void)Post:(NSString *)url para:(NSDictionary *)para finish:(KYHTTPCallBack)finish {
    [IVNetwork requestPostWithUrl:url paramters:para completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            !finish ?: finish(result.body, nil);
        } else {
            !finish ?: finish(result, error);
        }
    }];
}

+ (void)createDepisit:(NSString *)amount finish:(KYHTTPCallBack)finish {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"amount"] = amount;
    dic[@"merchant"] = @"A01";
    dic[@"currency"] = @"CNY";
    [self Post:@"deposit/MMPayment" para:dic finish:finish];
}

+ (void)commitDepisit:(NSString *)billId receiptImg:(NSString *)imgName transactionImg:(NSArray *)imgNames finish:(KYHTTPCallBack)finish {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"transactionId"] = billId;
    dic[@"opType"] = @"1"; //确认存款
    dic[@"receiptImg"] = imgName;
    dic[@"transactionImg"] = [imgNames componentsJoinedByString:@";"];
    dic[@"merchant"] = @"A01";
    dic[@"currency"] = @"CNY";
    [self Post:@"deposit/depositOperate" para:dic finish:finish];
}

+ (void)cancelDepisit:(NSString *)billId finish:(KYHTTPCallBack)finish {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"transactionId"] = billId;
    dic[@"opType"] = @"2"; //取消存款
    dic[@"merchant"] = @"A01";
    dic[@"currency"] = @"CNY";
    [self Post:@"deposit/depositOperate" para:dic finish:finish];
}
@end
