//
//  BTTModifyEmailController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTModifyEmailController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTModifyEmailController (LoadData)

@property (nonatomic, strong) NSMutableArray *sheetDatas;

- (void)loadMainData;

@end

NS_ASSUME_NONNULL_END
