//
//  BTTVideoGameCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 27/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTVideoGameModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTVideoGameCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstants;

@property (nonatomic, strong) BTTVideoGameModel *model;

@property (nonatomic, strong) NSMutableArray *favorModelArr;
@end

NS_ASSUME_NONNULL_END
