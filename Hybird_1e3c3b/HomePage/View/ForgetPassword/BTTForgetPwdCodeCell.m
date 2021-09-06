//
//  BTTForgetPwdCodeCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPwdCodeCell.h"
#import "BTTMeMainModel.h"

@interface BTTForgetPwdCodeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (weak, nonatomic) IBOutlet UIView *captchaBg;

@end

@implementation BTTForgetPwdCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    _detailTextField.textColor = [UIColor blackColor];
    self.captchaBg.layer.cornerRadius = 4.0;
    self.codeImage.clipsToBounds = true;
    self.codeImage.layer.cornerRadius = 4.0;
    UITapGestureRecognizer *refreshCode = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshCode:)];
    [self.codeImage addGestureRecognizer:refreshCode];
}

- (void)refreshCode:(UITapGestureRecognizer *)tap {
    if (self.clickEventBlock) {
        self.clickEventBlock(tap);
    }
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.detailTextField.placeholder = model.name;
    self.logo.image = [UIImage imageNamed:model.iconName];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_detailTextField.placeholder attributes:
    @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],
                 NSFontAttributeName:_detailTextField.font
         }];
    _detailTextField.attributedPlaceholder = attrString;
}


@end
