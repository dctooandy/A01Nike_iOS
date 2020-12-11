//
//  BTTForgetPwdCodeCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetPwdCodeCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UITextField *detailTextField;

@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@property (nonatomic, strong) BTTMeMainModel *model;

@end

NS_ASSUME_NONNULL_END
