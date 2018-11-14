//
//  BTTLoginCodeCell.h
//  Hybird_A01
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginCodeCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;


@end

NS_ASSUME_NONNULL_END
