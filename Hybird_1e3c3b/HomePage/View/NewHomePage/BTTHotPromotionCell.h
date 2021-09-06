//
//  BTTHotPromotionCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 13/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BTTPromotionProcessModel;

@interface BTTHotPromotionCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTPromotionProcessModel *model;

@end

NS_ASSUME_NONNULL_END
