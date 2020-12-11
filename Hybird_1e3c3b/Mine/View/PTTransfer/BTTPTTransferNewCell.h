//
//  BTTPTTransferCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 26/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTPTTransferNewCell : BTTBaseCollectionViewCell


@property (weak, nonatomic) IBOutlet UIButton *PTBtn;

@property (weak, nonatomic) IBOutlet UIButton *useableBtn;

@property (weak, nonatomic) IBOutlet UILabel *userableLabel;

@property (weak, nonatomic) IBOutlet UILabel *PTLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@end

NS_ASSUME_NONNULL_END
