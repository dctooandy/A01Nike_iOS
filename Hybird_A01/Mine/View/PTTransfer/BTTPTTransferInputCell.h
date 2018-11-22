//
//  BTTPTTransferInputCell.h
//  Hybird_A01
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTPTTransferInputCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

@property (nonatomic, strong) BTTMeMainModel *model;

@end

NS_ASSUME_NONNULL_END
