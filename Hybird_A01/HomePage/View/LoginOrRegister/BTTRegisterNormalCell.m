//
//  BTTRegisterNormalCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTRegisterNormalCell.h"

@interface BTTRegisterNormalCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *normalBtn;

@property (weak, nonatomic) IBOutlet UIButton *quickBtn;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation BTTRegisterNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.bgView.layer.cornerRadius = 5;
    self.tagLabel.layer.cornerRadius = 2;
    [self.accountTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verifyTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *refreshCode = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshCode:)];
    [self.codeImageView addGestureRecognizer:refreshCode];
}

- (void)refreshCode:(UITapGestureRecognizer *)tap {
    if (self.clickEventBlock) {
        self.clickEventBlock(tap);
    }
}

- (IBAction)normalBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)quickBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


- (IBAction)showBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = !sender.selected;
}

- (void)textFieldChange:(UITextField *)textField {
    if (textField.tag == 1010) {
        if (textField.text.length > 9) {
            textField.text = [textField.text substringToIndex:9];
        }
    } else if (textField.tag == 1012) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    } else if (textField.tag == 1011) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    } else {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
    
}


@end
