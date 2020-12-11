//
//  BTTChooseCurrencyCell.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 27/11/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTUserGameCurrencyModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnActionBlock)(NSString * currencyStr);

@interface BTTChooseCurrencyCell : BTTBaseCollectionViewCell
@property (nonatomic, copy) NSString * gameTitleStr;
@property (nonatomic, copy) BtnActionBlock btnActionBlock;
@property (nonatomic, strong) BTTUserGameCurrencyModel * model;
@end

NS_ASSUME_NONNULL_END
