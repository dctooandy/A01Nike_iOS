//
//  BTTHomePageActivitiesCell.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/12.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTActivityModel;

typedef void (^ReloadImagesBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageActivitiesCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTActivityModel *activityModel;

@property (nonatomic, copy) ReloadImagesBlock reloadBlock;

@end

NS_ASSUME_NONNULL_END
