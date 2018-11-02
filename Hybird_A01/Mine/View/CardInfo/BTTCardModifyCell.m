//
//  BTTCardModifyCell.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCardModifyCell.h"

@interface BTTCardModifyCell ()<UITextFieldDelegate>

@end

@implementation BTTCardModifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_textField setValue:[UIColor colorWithHexString:@"818791"] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.delegate = self;
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

@end
