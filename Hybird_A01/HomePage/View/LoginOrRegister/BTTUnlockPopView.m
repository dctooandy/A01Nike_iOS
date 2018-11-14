//
//  BTTUnlockPopView.m
//  Hybird_A01
//
//  Created by Domino on 13/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTUnlockPopView.h"

@interface BTTUnlockPopView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *infoTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation BTTUnlockPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.infoTextField.delegate = self;
}


- (IBAction)confrimClick:(UIButton *)sender {
    if (self.nameTextField.text.length || self.phoneTextField.text.length || self.infoTextField.text.length) {
        
    } else {
        
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}


@end
