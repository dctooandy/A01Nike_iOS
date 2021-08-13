//
//  BTTForgetPwdOneCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPwdOneCell.h"
#import "BTTMeMainModel.h"

@interface BTTForgetPwdOneCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logo;


@end

@implementation BTTForgetPwdOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    _detailTextField.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.0;
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
