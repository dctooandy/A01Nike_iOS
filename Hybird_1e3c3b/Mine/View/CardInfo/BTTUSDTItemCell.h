//
//  BTTUSDTItemCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 24/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTUSDTItemCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) NSArray *usdtDatas;

@property (nonatomic, copy) void(^selectPayType)(NSInteger tag);

- (void)setUsdtDatasWithArray:(NSArray *)usdtDatas;

@end

NS_ASSUME_NONNULL_END
