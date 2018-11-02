//
//  BTTMeInfoCell.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTMeInfoCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTMeMainModel *model;

@end

NS_ASSUME_NONNULL_END
