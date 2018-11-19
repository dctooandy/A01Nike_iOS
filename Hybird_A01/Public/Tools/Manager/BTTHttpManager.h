//
//  BTTHttpManager.h
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTHttpManager : NSObject
//获取银行卡列表
+ (void)fetchBankListWithCompletion:(IVRequestCallBack)completion;
//获取手机、邮箱、银行卡、比特币钱包绑定状态
+ (void)fetchBindStatusWithCompletion:(IVRequestCallBack)completion;
@end
