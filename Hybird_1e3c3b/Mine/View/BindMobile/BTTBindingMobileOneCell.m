//
//  BTTBindingMobileOneCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBindingMobileOneCell.h"
#import "BTTMeMainModel.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"//数字和字母

@interface BTTBindingMobileOneCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstants;
@end

@implementation BTTBindingMobileOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (@available(iOS 13.0,*)) {
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:
        @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],
                     NSFontAttributeName:_textField.font
             }];
        _textField.attributedPlaceholder = attrString;
    }

    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldDidchanged:) forControlEvents:UIControlEventEditingChanged];
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor =  COLOR_RGBA(36, 40, 49, 1);
    [self setSelectedBackgroundView:backgroundView];
    if (SCREEN_WIDTH == 320) {
        self.nameLabel.font = kFontSystem(14);
        self.textField.font = kFontSystem(13);
    }
}

- (void)textFieldDidchanged:(id)sender{
    if (_textFieldChanged) {
        _textFieldChanged(_textField.text);
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.model.name isEqualToString:@"金额"])
    {
        return (UserForzenStatus ? NO : YES);
    }else{
        return true;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.model.name isEqualToString:@"钱包地址"]||[self.model.name isEqualToString:@"确认地址"]) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    } else if ([self.model.name isEqualToString:@"金额"] && [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString insertString:string atIndex:range.location];
        NSInteger flag = 0;
        const NSInteger limited = 2;//小数点后需要限制的个数
        for (int i = (int)(futureString.length - 1); i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                if (flag > limited) {
                    [MBProgressHUD showError:@"取款金额仅支持小数点后两位" toView:nil];
                    return NO;
                }
                break;
            }
            flag++;
        }
        return YES;
    }
    else if ([self.model.name isEqualToString:@"资金密码"]) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6){
            return NO;
        }
        return YES;
    }
    else if ([self.model.name isEqualToString:@"手机号码"] && textField.text.length >= 11 && string.length > 0) {
        return false;
    }
    else {
        return YES;
    }
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.textField.placeholder = model.iconName;
    self.textField.text = model.desc;
    if ([model.name isEqualToString:@"性别"] ||
        [model.name isEqualToString:@"出生日期"] ||
        [model.name isEqualToString:@"开户行"] ||
        [model.name isEqualToString:@"卡片类别"] ||
        [model.name isEqualToString:@"开户省份"] ||
        [model.name isEqualToString:@"开户城市"] ||
        [model.name isEqualToString:@"设置/修改密码"] ||
        [model.name isEqualToString:@"绑定手机"] ||
        [model.name isEqualToString:@"绑定邮箱"] ||
        [model.name isEqualToString:@"记录类型"] ||
        [model.name isEqualToString:@"时间"] ||
        [model.name isEqualToString:@"AG国际厅"] ||
        [model.name isEqualToString:@"波音厅"] ||
        [model.name isEqualToString:@"个人资料"] ||
        [model.name isEqualToString:@"银行卡资料"] ||
        [model.name isEqualToString:@"钱包管理"] ||
        [model.name isEqualToString:@"修改限红"] ||
        [model.name isEqualToString:@"短信订阅"] ||
        [model.name isEqualToString:@"游戏币种"]) {
        self.rightConstants.constant = 46;
        self.mineArrowsType = BTTMineArrowsTypeNoHidden;
        self.textField.userInteractionEnabled = NO;
    } else {
        if ([model.name isEqualToString:@"持卡人姓名"] ||
            (([model.name isEqualToString:@"预留信息"] ||
              [model.name isEqualToString:@"真实姓名"] ||
              [model.name isEqualToString:@"邮箱地址"] ||
              [model.name isEqualToString:@"已绑定手机"] ||
              [model.name isEqualToString:@"已绑定邮箱地址"] ||
              [model.name isEqualToString:@"手机号"]) &&
             model.desc.length != 0)) {
                self.textField.userInteractionEnabled = NO;
            } else {
                self.textField.userInteractionEnabled = YES;
            }
        self.rightConstants.constant = 20;
        self.mineArrowsType = BTTMineArrowsTypeHidden;
    }
    if ([model.name isEqualToString:@"备注"] ||
        [model.name isEqualToString:@"波音厅"]) {
        self.mineSparaterType = BTTMineSparaterTypeNone;
    }
        
    if ([model.name isEqualToString:@"卡号"]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if ([model.name isEqualToString:@"出生日期"]) {
        if (([IVNetwork savedUserInfo].starLevel == 5 || [IVNetwork savedUserInfo].starLevel == 6) && [IVNetwork savedUserInfo].birthday.length) {
            self.textField.textColor = [UIColor colorWithHexString:@"818791"];
        } else {
            self.textField.textColor = [UIColor whiteColor];
        }
    } else {
        if (model.isError) {
            self.textField.textColor = [UIColor colorWithHexString:@"d13847"];
        } else {
            if (model.resultCode.length) {
                self.textField.textColor = [UIColor colorWithHexString:@"818791"];
            } else {
                self.textField.textColor =  [UIColor whiteColor];
            }
        }
    }
    
    if ([model.name isEqualToString:@"存款姓名"] ||
        [model.name isEqualToString:@"存款金额"] ||
        [model.name isEqualToString:@"存款方式"] ||
        [model.name isEqualToString:@"存款时间"] ||
        [model.name isEqualToString:@"存款地点"] ||
        [model.name isEqualToString:@"存款银行"] ||
        [model.name isEqualToString:@"存款卡号"]) {
        if (model.isError) {
            if ([model.name isEqualToString:@"存款方式"] || [model.name isEqualToString:@"存款时间"] || [model.name isEqualToString:@"存款地点"]) {
                self.mineArrowsType = BTTMineArrowsTypeNoHidden;
                self.rightConstants.constant = 46;
            } else {
                self.rightConstants.constant = 20;
                self.mineArrowsType = BTTMineArrowsTypeHidden;
            }
            self.textField.userInteractionEnabled = NO;
        } else {
            self.textField.userInteractionEnabled = NO;
            if ([model.name isEqualToString:@"存款方式"] || [model.name isEqualToString:@"存款时间"] || [model.name isEqualToString:@"存款地点"]) {
                self.textField.userInteractionEnabled = NO;
                self.mineArrowsType = BTTMineArrowsTypeNoHidden;
                self.rightConstants.constant = 46;
            } else {
                self.rightConstants.constant = 20;
                self.mineArrowsType = BTTMineArrowsTypeHidden;
                if (model.resultCode.integerValue) {
                    self.textField.userInteractionEnabled = YES;
                } else {
                    self.textField.userInteractionEnabled = NO;
                }
            }
        }
    }
    if ([model.name isEqualToString:@"退出登录"]) {
        self.textField.userInteractionEnabled = NO;
    }

    if ([model.name isEqualToString:@"资金密码"] && [model.iconName isEqualToString:@"没有资金密码？点击设置资金密码"]) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:@"没有资金密码？点击设置资金密码"];
        NSRange range = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        [str addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed: 0.24 green: 0.60 blue: 0.97 alpha: 1.00],NSFontAttributeName:kFontSystem(14)} range:range];
        self.textField.attributedPlaceholder = str;
    } else {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:model.iconName];
        NSRange range = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:range];
        [str addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"C0C0C0"],NSFontAttributeName:kFontSystem(14)} range:range];
        self.textField.attributedPlaceholder = str;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

@end
