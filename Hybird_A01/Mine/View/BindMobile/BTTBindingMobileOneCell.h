//
//  BTTBindingMobileOneCell.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"


@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTBindingMobileOneCell : BTTBaseCollectionViewCell


@property (nonatomic, strong) BTTMeMainModel *model;

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

NS_ASSUME_NONNULL_END
