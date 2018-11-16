//
//  BTTMineViewController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMineViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTMineViewController (LoadData)

@property (nonatomic, strong) NSMutableArray *personalInfos;

@property (nonatomic, strong) NSMutableArray *paymentDatas;

@property (nonatomic, strong) NSMutableArray *mainDataOne;

@property (nonatomic, strong) NSMutableArray *mainDataTwo;

@property (nonatomic, strong) NSMutableArray *mainDataThree;





- (void)loadMeAllData;

- (void)loadBindStatus;

@end

NS_ASSUME_NONNULL_END
