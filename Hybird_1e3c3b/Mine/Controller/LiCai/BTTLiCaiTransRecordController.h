//
//  BTTLiCaiTransRecordController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/27/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTLiCaiTransferRecordModel.h"
#import "BTTInterestRecordsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLiCaiTransRecordController : BTTCollectionViewController
@property (nonatomic, assign) NSInteger transferType;
@property (nonatomic, assign) NSInteger lastDays;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong)NSMutableArray <BTTLiCaiTransferRecordItemModel *> * modelArr;
@property (nonatomic, strong)NSMutableArray <BTTInterestRecordsItemModel *> * interestModelArr;
- (void)setupElements;
@end

NS_ASSUME_NONNULL_END
