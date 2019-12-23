//
//  BTTRegisterNinameNormalCell.m
//  Hybird_A01
//
//  Created by Domino on 22/04/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTRegisterNinameNormalCell.h"

@interface BTTRegisterNinameNormalCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *normalBtn;

@property (weak, nonatomic) IBOutlet UIButton *quickBtn;

@end

@implementation BTTRegisterNinameNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.bgView.layer.cornerRadius = 5;
    [self.phoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verifyTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshCode)];
    [self.codeImageView addGestureRecognizer:tap];
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (void)refreshCode {
    if (self.refreshEventBlock) {
        self.refreshEventBlock();
    }
}


- (void)textFieldChange:(UITextField *)textField {
    if (textField.tag == 1012) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    } else {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

@end
