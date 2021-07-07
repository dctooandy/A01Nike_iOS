//
//  BTTPasswordCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPasswordCell.h"
#import "BTTMeMainModel.h"

@interface BTTPasswordCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;
@property (nonatomic, assign) NSTextAlignment currentAlign;


@end

@implementation BTTPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:
    @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],
                 NSFontAttributeName:_textField.font
         }];
    _textField.attributedPlaceholder = attrString;
    _textField.delegate = self;
    _textField.secureTextEntry = YES;
    _currentAlign = NSTextAlignmentLeft;
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
- (void)disableSecureText:(BOOL)disableSecure withTextAlign:(NSTextAlignment)align
{
    _textField.secureTextEntry = !disableSecure;
    [_eyeButton setHidden:disableSecure];
    _currentAlign = align;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.eyeButton.hidden == NO)
    {
        [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-55);
        }];
    }
    [_textField setTextAlignment:self.currentAlign];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.currentAlign;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:
                                      @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],
                                        NSFontAttributeName:_textField.font
                                        ,NSParagraphStyleAttributeName:paragraphStyle
                                      }];
    _textField.attributedPlaceholder = attrString;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1000) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6){
            return NO;
        }
        return YES;
    } else {
        return YES;
    }
}

@end
