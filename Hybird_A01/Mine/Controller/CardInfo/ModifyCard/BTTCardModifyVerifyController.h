//
//  BTTCardModifyVerifyController.h
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTBankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTCardModifyVerifyController : BTTCollectionViewController

@property (nonatomic, assign) BTTSafeVerifyType safeVerifyType;
@property(nonatomic, copy) NSString *bankNumber;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *validateId;

@property (nonatomic, strong) BTTBankModel *bankModel;

@end

NS_ASSUME_NONNULL_END
