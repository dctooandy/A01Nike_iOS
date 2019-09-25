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
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:
    @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],
                 NSFontAttributeName:_textField.font
         }];
    _textField.attributedPlaceholder = attrString;
    _textField.delegate = self;
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

@end
