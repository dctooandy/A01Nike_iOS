//
//  BTTDiscountsViewController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTDiscountsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTDiscountsViewController (LoadData)

- (void)loadMainData;

- (void)makeCallWithPhoneNum:(NSString *)phone;

- (void)getLive800InfoDataWithResponse:(BTTLive800ResponseBlock)responseBlock;

@property (nonatomic, strong) NSMutableArray *sheetDatas;


@end

NS_ASSUME_NONNULL_END
