//
//  BTTBindingMobileOneCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBindingMobileOneCell.h"
#import "BTTMeMainModel.h"

@interface BTTBindingMobileOneCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstants;
@end

@implementation BTTBindingMobileOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_textField setValue:[UIColor colorWithHexString:@"818791"] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.delegate = self;
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor =  COLOR_RGBA(36, 40, 49, 1);
    [self setSelectedBackgroundView:backgroundView];
    if (SCREEN_WIDTH == 320) {
        self.nameLabel.font = kFontSystem(14);
        self.textField.font = kFontSystem(13);
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
        [model.name isEqualToString:@"修改密码"] ||
        [model.name isEqualToString:@"绑定手机"] ||
        [model.name isEqualToString:@"绑定邮箱"] ||
        [model.name isEqualToString:@"记录类型"] ||
        [model.name isEqualToString:@"时间"] ||
        [model.name isEqualToString:@"AG国际厅"] ||
        [model.name isEqualToString:@"波音厅"] ||
        [model.name isEqualToString:@"个人资料"] ||
        [model.name isEqualToString:@"银行卡资料"] ||
        [model.name isEqualToString:@"修改限红"] ||
        [model.name isEqualToString:@"短信订阅"]) {
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
        self.rightConstants.constant = 15;
        self.mineArrowsType = BTTMineArrowsTypeHidden;
    }
    
    if ([model.name isEqualToString:@"卡号"]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

@end
