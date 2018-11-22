//
//  BTTPTTransferInputCell.m
//  Hybird_A01
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPTTransferInputCell.h"
#import "BTTMeMainModel.h"

@interface BTTPTTransferInputCell ()<UITextFieldDelegate>




@end

@implementation BTTPTTransferInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _amountTextField.delegate = self;
    [_amountTextField setValue:[UIColor colorWithHexString:@"818791"] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.amountTextField.placeholder = model.iconName;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

@end
