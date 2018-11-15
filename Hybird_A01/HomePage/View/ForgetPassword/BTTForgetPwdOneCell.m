//
//  BTTForgetPwdOneCell.m
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPwdOneCell.h"
#import "BTTMeMainModel.h"

@interface BTTForgetPwdOneCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation BTTForgetPwdOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _detailTextField.textColor = [UIColor whiteColor];
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.detailTextField.placeholder = model.iconName;
    [_detailTextField setValue:[UIColor colorWithHexString:@"818791"] forKeyPath:@"_placeholderLabel.textColor"];
}



@end
