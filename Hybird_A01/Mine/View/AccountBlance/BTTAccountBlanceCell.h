//
//  BTTAccountBlanceCell.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTAccountBlanceCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;


@property (nonatomic, strong) BTTMeMainModel *model;

@end

NS_ASSUME_NONNULL_END
