//
//  BTTLoginCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginCell.h"

@interface BTTLoginCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;



@end

@implementation BTTLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.bgView.layer.cornerRadius = 5;
    self.codeLabel.layer.cornerRadius = 2;
    self.accountTextField.delegate = self;
    self.pwdTextField.delegate = self;
}


#pragma mark - delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (IBAction)showPwdClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = !sender.selected;
}


@end
