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

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation BTTForgetPwdCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _detailTextField.textColor = [UIColor whiteColor];
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
    self.nameLabel.text = model.name;
    self.detailTextField.placeholder = model.iconName;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_detailTextField.placeholder attributes:
    @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],
                 NSFontAttributeName:_detailTextField.font
         }];
    _detailTextField.attributedPlaceholder = attrString;
}


@end
