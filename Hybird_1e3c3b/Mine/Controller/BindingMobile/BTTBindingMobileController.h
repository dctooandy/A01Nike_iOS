//
//  BTTBindingMobileController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

@class BTTBankModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTBindingMobileController : BTTCollectionViewController

@property (nonatomic, assign) BTTSafeVerifyType mobileCodeType;

@property (nonatomic, strong) BTTBankModel *bankModel;

@property (nonatomic, copy) NSString *changeMobileValidateId;

@property (nonatomic, assign) BOOL showNotice;

@property (nonatomic, assign) BOOL isWithdrawIn;

@property (nonatomic, assign) BOOL isSellUsdtIn;

- (void)setupElements;

@end

NS_ASSUME_NONNULL_END
