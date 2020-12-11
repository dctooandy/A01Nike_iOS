//
//  BTTLastWeekCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTXimaLastWeekItemModel;
@class BTTXimaItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTLastWeekCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTXimaLastWeekItemModel *model;
@property (nonatomic, strong) BTTXimaItemModel *itemModel;

@end

NS_ASSUME_NONNULL_END
