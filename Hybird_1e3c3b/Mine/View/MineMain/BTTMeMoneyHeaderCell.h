//
//  BTTMeMoneyHeaderCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTMeMoneyHeaderCell : BTTBaseCollectionViewCell

@property (nonatomic, copy) void(^rechargeAssistantTap)(void);

- (void)setAssistantShow:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
