//
//  BTTModifyBankRecordController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTModifyBankRecordModel.h"

@class BTTModifyBankRecordModel;
NS_ASSUME_NONNULL_BEGIN

@interface BTTModifyBankRecordController : BTTCollectionViewController
@property (nonatomic, strong)NSMutableDictionary * params;
@property (nonatomic, strong)BTTModifyBankRecordModel * model;
@end

NS_ASSUME_NONNULL_END
