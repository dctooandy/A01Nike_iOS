//
//  BTTLoginCodeCell.m
//  Hybird_A01
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginCodeCell.h"

@interface BTTLoginCodeCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;


@end

@implementation BTTLoginCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 4;
    self.tagLabel.layer.cornerRadius = 2;
    [self.accountTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    UITapGestureRecognizer *refreshCode = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshCode:)];
    [self.codeImageView addGestureRecognizer:refreshCode];
}

- (void)refreshCode:(UITapGestureRecognizer *)tap {
    if (self.clickEventBlock) {
        self.clickEventBlock(tap);
    }
}

- (IBAction)showBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = !sender.selected;
}

- (void)textFieldChange:(UITextField *)textField {
    if (textField.text.length > 9) {
        [MBProgressHUD showError:@"账号长度不能超过9位" toView:nil];
        textField.text = [textField.text substringToIndex:9];
    }
}


@end
