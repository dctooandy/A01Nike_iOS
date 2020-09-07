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
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_amountTextField.placeholder attributes:
    @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],
                 NSFontAttributeName:_amountTextField.font
         }];
    _amountTextField.attributedPlaceholder = attrString;
    _unitLabel.text = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT" :@"元";
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
