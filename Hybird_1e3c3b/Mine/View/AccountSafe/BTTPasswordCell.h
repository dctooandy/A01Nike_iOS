//
//  BTTPasswordCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTPasswordCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) BTTMeMainModel *model;

@end

NS_ASSUME_NONNULL_END
