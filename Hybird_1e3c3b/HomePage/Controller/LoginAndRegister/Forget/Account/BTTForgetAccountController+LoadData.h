//
//  BTTForgetAccountController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/12/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetAccountController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetAccountController (LoadData)
@property (nonatomic, strong) NSMutableArray *mainData;
-(void)loadMainData;
-(void)sendCodeByPhone:(NSString *)phone;
-(void)checkCustomerBySmsCode:(NSString *)code;
@end

NS_ASSUME_NONNULL_END
