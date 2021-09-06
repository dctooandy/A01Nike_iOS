//
//  BTTLiCaiViewController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/29/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ServerTimeCompleteBlock)(NSString * timeStr);
typedef void (^ShowOutPopViewCompleteBlock)(NSMutableArray * modelArr);
typedef void (^TransferCompleteBlock)(void);

@interface BTTLiCaiViewController (LoadData)
-(void)loadYebConfig;
-(void)loadInterestSum;
-(void)loadLocalAmount;
-(void)loadTransferInRecords:(ShowOutPopViewCompleteBlock)completeBlock;
-(void)transferOut:(TransferCompleteBlock)completeBlock;
-(void)transferIn:(NSString *)amount completeBlock:(TransferCompleteBlock)completeBlock;
-(void)loadServerTime:(ServerTimeCompleteBlock)completeBlock;
@end

NS_ASSUME_NONNULL_END
