//
//  BTTHomePageDiscountCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
@class BTTPromotionProcessModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageDiscountCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTPromotionProcessModel *model;

@property (nonatomic, assign) BOOL isShowOverView;

@end

NS_ASSUME_NONNULL_END
