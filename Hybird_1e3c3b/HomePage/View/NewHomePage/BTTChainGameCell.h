//
//  BTTChainGameCell.h
//  Hybird_1e3c3b
//
//  Created by Andy on 2022/4/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTASGameModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTTChainGameCell : BTTBaseCollectionViewCell
@property (strong , nonatomic) BTTASGameModel * asGameData;
@end

NS_ASSUME_NONNULL_END
