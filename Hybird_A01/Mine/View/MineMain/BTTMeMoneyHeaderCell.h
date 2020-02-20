//
//  BTTMeMoneyHeaderCell.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTMeMoneyHeaderCell : BTTBaseCollectionViewCell

@property (nonatomic, copy) void(^rechargeAssistantTap)(void);

@end

NS_ASSUME_NONNULL_END
