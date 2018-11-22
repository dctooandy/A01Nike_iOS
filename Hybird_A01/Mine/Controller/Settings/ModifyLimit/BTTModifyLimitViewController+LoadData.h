//
//  BTTModifyLimitViewController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 22/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTModifyLimitViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTModifyLimitViewController (LoadData)

@property (nonatomic, strong) NSMutableArray *agin;

@property (nonatomic, strong) NSMutableArray *bbin;


- (void)loadMainData;

- (void)loadSetBetLimitWithAgin:(NSString *)agin bbin:(NSString *)bbin;

@end

NS_ASSUME_NONNULL_END
