//
//  BTTHotPromotionCell.h
//  Hybird_A01
//
//  Created by Domino on 13/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BTTPromotionModel;

@interface BTTHotPromotionCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTPromotionModel *model;

@end

NS_ASSUME_NONNULL_END
