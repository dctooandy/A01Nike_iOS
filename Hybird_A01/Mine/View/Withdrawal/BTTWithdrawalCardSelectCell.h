//
//  BTTWithdrawalCardSelectCell.h
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"
#import "BTTBankModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTTWithdrawalCardSelectCell : BTTBaseCollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bfb_discount;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property(nonatomic, strong)BTTBankModel *model;

@end

NS_ASSUME_NONNULL_END
