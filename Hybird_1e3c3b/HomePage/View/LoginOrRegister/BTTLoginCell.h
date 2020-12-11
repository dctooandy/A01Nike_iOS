//
//  BTTLoginCell.h
//  Hybird_1e3c3b
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eyeBtnLeftConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendBtnLeftConstants;

@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;

@end

NS_ASSUME_NONNULL_END
