//
//  BTTVIPClubPageActivitiesCell.h
//  Hybird_1e3c3b
//
//  Created by Andy on 2021/05/31.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTActivityModel;

typedef void (^ReloadImagesBlock)(void);
typedef void (^SelectImageItemIndex)(NSInteger);

NS_ASSUME_NONNULL_BEGIN

@interface BTTVIPClubPageActivitiesCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTActivityModel *activityModel;

@property (nonatomic, copy) ReloadImagesBlock reloadBlock;
@property (nonatomic, copy) SelectImageItemIndex selectBlock;
- (void)setConfigForFirstCell:(BOOL)firstCell;
@end

NS_ASSUME_NONNULL_END
