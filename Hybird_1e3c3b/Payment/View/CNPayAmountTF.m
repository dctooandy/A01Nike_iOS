//
//  CNPayAmountTF.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayAmountTF.h"

@implementation CNPayAmountTF


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.font = [UIFont systemFontOfSize:14];
    self.delegate = self;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textAlignment = NSTextAlignmentRight;
    self.keyboardType = UIKeyboardTypeDecimalPad;
    [self addTarget:self action:@selector(textFieldEditingChanged) forControlEvents:UIControlEventEditingChanged];
    self.placeholder = @"请输入金额";
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入金额" attributes:
    @{NSForegroundColorAttributeName:self.textColor,
                 NSFontAttributeName:self.font
         }];
    self.attributedPlaceholder = attrString;
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"pay_TFDelete"] forState:UIControlStateNormal];
}

- (void)textFieldEditingChanged {
    if (_editingChanged) {
        _editingChanged(self.text, [self.text isEqualToString:@""] || self.text.length == 0);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text hasSuffix:@"."]) {
        self.text = [self.text stringByAppendingString:@"0"];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *futureText = [NSMutableString stringWithString:textField.text];
    [futureText insertString:string atIndex:range.location];
    NSString *regex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,20}(([.]\\d{0,2})?)))?";
    NSPredicate *predcicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predcicate evaluateWithObject:futureText];
}

@end
