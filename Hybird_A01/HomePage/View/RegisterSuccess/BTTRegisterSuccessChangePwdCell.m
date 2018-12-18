//
//  BTTRegisterSuccessChangePwdCell.m
//  Hybird_A01
//
//  Created by Domino on 11/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTRegisterSuccessChangePwdCell.h"

@interface BTTRegisterSuccessChangePwdCell ()<UITextFieldDelegate>

@end

@implementation BTTRegisterSuccessChangePwdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.pwdTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

@end
