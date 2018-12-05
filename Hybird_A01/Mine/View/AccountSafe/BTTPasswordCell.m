//
//  BTTPasswordCell.m
//  Hybird_A01
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPasswordCell.h"
#import "BTTMeMainModel.h"

@interface BTTPasswordCell ()<UITextFieldDelegate>



@end

@implementation BTTPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_textField setValue:[UIColor colorWithHexString:@"818791"] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.delegate = self;
    _textField.secureTextEntry = YES;
}

- (IBAction)showClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _textField.secureTextEntry = NO;
    } else {
        _textField.secureTextEntry = YES;
    }
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.textField.placeholder = model.iconName;
    if ([model.name isEqualToString:@"新密码"]) {
        self.mineSparaterType = BTTMineSparaterTypeNone;
    }
}

@end
