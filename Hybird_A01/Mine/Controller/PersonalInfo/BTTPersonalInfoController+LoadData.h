//
//  BTTPersonalInfoController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 22/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPersonalInfoController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTPersonalInfoController (LoadData)

@property (nonatomic, strong) NSMutableArray *sheetDatas;

- (void)loadMainData;

@end

NS_ASSUME_NONNULL_END
