//
//  CNPayRequestManager.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayRequestManager.h"
#import <objc/runtime.h>
#import "BTTHttpManager.h"
#import "CNPayOrderModel.h"
#import "CNPayConstant.h"

@implementation CNPayRequestManager

+ (void)requestWithUrl:(NSString *)url parameters:(NSDictionary *)params handler:(KYHTTPCallBack)completeHandler {
    [[IVHttpManager shareManager] sendRequestWithUrl:url parameters:params callBack:^(id  _Nullable response, NSError * _Nullable error) {
    }];
}
+ (void)cacheWithUrl:(NSString *)url parameters:(NSDictionary *)params handler:(KYHTTPCallBack)completeHandler {
    [[IVHttpManager shareManager] sendRequestWithMethod:KYHTTPMethodPOST url:url parameters:params cache:YES cacheTimeout:3600 * 24 callBack:^(BOOL isCache, id  _Nullable response, NSError * _Nullable error) {
    } originCallBack:^(id  _Nullable response, NSError * _Nullable error) {
    }];
}

#pragma mark - ========================* Payment *===========================================
/// 预设支付方式总个数
NSInteger const kPayTypeTotalCount = 30;

+ (void)queryAllChannelCompleteHandler:(KYHTTPCallBack)completeHandler {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@([IVNetwork savedUserInfo].starLevel) forKey:@"customerLevel"];
    [params setValue:[IVNetwork savedUserInfo].depositLevel forKey:@"depositLevel"];
    [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
    
    [IVNetwork requestPostWithUrl:kPaymentValidate paramters:params completionBlock:completeHandler];
}

//#pragma mark - ========================* Form 表单 *===========================================
//
+ (NSString *)submitPayFormWithOrderModel:(CNPayOrderModel *)model {
    
    NSString *loginName = [IVNetwork savedUserInfo].loginName;
    id PayModel = [model class];
    
    NSMutableString *htmljs = [[NSMutableString alloc] init];
    [htmljs appendFormat:@"%@", [NSString stringWithFormat:@"<form id=\"codePayForm\" name=\"query\" action=\"%@\" method=\"get\" class=\"form\">\n", model.payUrl]];
    [htmljs appendFormat:@"%@", [NSString stringWithFormat:@"<input type=\"hidden\" name=\"%@\" value=\"%@\">\n", @"loginname", loginName]];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(PayModel, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        id value = [model valueForKey:propName];
        [htmljs appendFormat:@"%@", [NSString stringWithFormat:@"<input type=\"hidden\" name=\"%@\" value=\"%@\">\n",propName,value]];
    }
    [htmljs appendFormat:@"%@",[NSString stringWithFormat:@"</form>"]];
    [htmljs appendFormat:@"%@",[NSString stringWithFormat:@"<script>document.getElementById(\"codePayForm\").submit();</script>"]];
    NSLog(@"\n%@\n", htmljs);
    return htmljs;
}

@end
