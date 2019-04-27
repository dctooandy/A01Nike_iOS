//
//  BTTRegisterNinameNormalCell.h
//  Hybird_A01
//
//  Created by Domino on 22/04/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTRegisterNinameNormalCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end

NS_ASSUME_NONNULL_END
