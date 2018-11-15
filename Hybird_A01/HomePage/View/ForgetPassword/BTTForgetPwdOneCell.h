//
//  BTTForgetPwdOneCell.h
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetPwdOneCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) BTTMeMainModel *model;

@property (weak, nonatomic) IBOutlet UITextField *detailTextField;


@end

NS_ASSUME_NONNULL_END
