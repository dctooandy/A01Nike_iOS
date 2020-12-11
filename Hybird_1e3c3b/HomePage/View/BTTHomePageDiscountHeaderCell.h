//
//  BTTHomePageDiscountHeaderCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

typedef void (^ReloadImagesBlock)(void);

@class BTTHomePageHeaderModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageDiscountHeaderCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTHomePageHeaderModel *headerModel;

@property (nonatomic, copy) ReloadImagesBlock reloadBlock;

@end

NS_ASSUME_NONNULL_END
