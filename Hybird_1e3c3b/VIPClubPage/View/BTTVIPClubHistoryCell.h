//
//  BTTVIPClubHistoryCell.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/4.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

typedef void (^MoreHistoryBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface BTTVIPClubHistoryCell : BTTBaseCollectionViewCell
@property (nonatomic, copy) MoreHistoryBlock moreBlock;
- (IBAction)moreBtnClick;
- (void)config;
@end

NS_ASSUME_NONNULL_END
