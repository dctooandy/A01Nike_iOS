//
//  BTTVIPHistorySideBarCell.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/9/7.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "VIPHistoryModel.h"
//typedef void (^sideTapAction)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN
@interface BTTVIPHistorySideBarCell : BTTBaseCollectionViewCell

- (void)sideBarConfigForCell:(VIPHistorySideBarModel *)model;
@end

NS_ASSUME_NONNULL_END
