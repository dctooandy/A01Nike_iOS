//
//  BTTBankModel.h
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

/**
 {
 bank_account_no_new = 7886567;
 bank_country = 河北省;
 customer_bank_id = 1000230152;
 bank_name = 招商银行;
 catalog = 0;
 bank_account_no = ****567;
 created_by = rkeytt01;
 login_name = rkeytt01;
 bank_city = 石家庄市;
 bank_account_name = **8;
 created_date = 2018-08-27 18:13:07;
 flag = 1;
 last_update = 2018-08-27 18:13:07;
 branch_name = uuehjejsjsj;
 customer_id = 1000757957;
 bank_account_type = 借记卡;
 priority_order = 1;
 last_updated_by = system;
 is_default = 1;
 }
 */

#import "JSONModel.h"

@interface BTTBankModel : JSONModel
/** 银行名称 */
@property (copy, nonatomic) NSString *bankName;
/** 支行银行名称 */
@property (copy, nonatomic) NSString *branchName;
/** 银行类型(借记卡/比特币) */
@property (copy, nonatomic) NSString *bankType;
/** 银行账户暗文 */
@property (copy, nonatomic) NSString *bankSecurityAccount;
/** 银行账户 */
@property (copy, nonatomic) NSString *bankAccount;
/** 账户持卡人名字 */
@property (copy, nonatomic) NSString *bankAccountName;
/** 是否默认银行卡 YES 是 */
@property (assign, nonatomic) BOOL isDefault;
/** 0 银行，1 比特币 */
@property (assign, nonatomic) BOOL isBTC;
/** 9 正在审核 */
@property (assign, nonatomic) NSInteger flag;
/** 省份 */
@property (copy, nonatomic) NSString *province;
/** 城市 */
@property (copy, nonatomic) NSString *city;
/** 银行卡的id */
@property (copy, nonatomic) NSString *customer_bank_id;
/** 银行卡logo */
@property (copy, nonatomic) NSString *banklogo;
/** 背景图 */
@property (copy, nonatomic) NSString *bankimage;
/** 比特币汇率 */
@property (copy, nonatomic) NSString *btcrate;
/** 比特币金额 */
@property (copy, nonatomic) NSString *btcamount;
/** 获取比特币汇率返回过来的 */
@property (copy, nonatomic) NSString *uuid;
/** 取款时选取控件显示的文字*/
@property(copy, nonatomic) NSString *withdrawText;
@end
