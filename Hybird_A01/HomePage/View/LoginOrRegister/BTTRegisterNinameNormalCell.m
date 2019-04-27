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
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


- (void)textFieldChange:(UITextField *)textField {
    if (textField.tag == 1012) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    } else {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
}

@end
