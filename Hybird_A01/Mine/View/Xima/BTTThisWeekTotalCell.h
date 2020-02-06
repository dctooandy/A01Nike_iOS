//
//  BTTThisWeekTotalCell.h
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTXimaTotalModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTThisWeekTotalCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTXimaTotalModel *model;
@property (nonatomic, strong) NSArray *history;

@end

NS_ASSUME_NONNULL_END
