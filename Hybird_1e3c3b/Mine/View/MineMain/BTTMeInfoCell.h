//
//  BTTMeInfoCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTMeInfoCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTMeMainModel *model;
@property (nonatomic, assign) BOOL isShowHot;
@end

NS_ASSUME_NONNULL_END
