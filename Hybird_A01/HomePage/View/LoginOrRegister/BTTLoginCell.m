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
    [self.accountTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];

}

- (IBAction)showPwdClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = !sender.selected;
}

- (void)textFieldChange:(UITextField *)textField {
    if (textField.text.length > 9) {
        [MBProgressHUD showMessagNoActivity:@"账号长度不能超过9位" toView:nil];
        textField.text = [textField.text substringToIndex:9];
    }
}


@end
