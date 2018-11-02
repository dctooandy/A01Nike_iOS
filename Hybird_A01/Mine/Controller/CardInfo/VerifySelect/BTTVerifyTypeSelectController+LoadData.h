//
//  BTTVerifyTypeSelectController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVerifyTypeSelectController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTVerifyTypeSelectController (LoadData)

@property (nonatomic, strong) NSMutableArray *sheetDatas;

- (void)loadMainData;

@end

NS_ASSUME_NONNULL_END
