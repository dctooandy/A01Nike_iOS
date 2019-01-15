//
//  BTTSaveMoneyErrorModel.h
//  Hybird_A01
//
//  Created by Domino on 14/01/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTSaveMoneyErrorModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *applier;

@property (nonatomic, copy) NSString *bank_account_name;

@property (nonatomic, copy) NSString *bank_account_no;

@property (nonatomic, copy) NSString *bank_name;

@property (nonatomic, copy) NSString *checker;

@property (nonatomic, assign) NSInteger check_staus;

@property (nonatomic, copy) NSString *created_by;

@property (nonatomic, copy) NSString *created_date;

@property (nonatomic, copy) NSString *customer_id;

@property (nonatomic, copy) NSString *deposit_by;

@property (nonatomic, copy) NSString *deposit_date;

@property (nonatomic, copy) NSString *deposit_location;

@property (nonatomic, copy) NSString *deposit_type;

@property (nonatomic, assign) NSInteger end_point;

@property (nonatomic, copy) NSString *end_point_url;

@property (nonatomic, copy) NSString *deposituration_id;

@property (nonatomic, copy) NSString *login_name;

@property (nonatomic, copy) NSString *pre_amount;

@property (nonatomic, copy) NSString *product_id;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *reference_id;

@property (nonatomic, copy) NSString *result_code;

@property (nonatomic, copy) NSString *result_text;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger trans_code;



@end

NS_ASSUME_NONNULL_END
