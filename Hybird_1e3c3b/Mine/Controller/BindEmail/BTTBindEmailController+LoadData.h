//
//  BTTBindEmailController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBindEmailController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTBindEmailController (LoadData)

- (void)loadMainData;

@property (nonatomic, strong) NSMutableArray *sheetDatas;

@end

NS_ASSUME_NONNULL_END
