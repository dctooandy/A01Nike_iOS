//
//  BTTBookMessageCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBookMessageCell.h"
#import "BTTMeMainModel.h"
#import "BTTSMSEmailModifyModel.h"

@interface BTTBookMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation BTTBookMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {
        self.titleLabel.font = kFontSystem(12);
        self.messageLabel.font = kFontSystem(12);
        self.emailLabel.font = kFontSystem(12);
    }
}


- (IBAction)emailBook:(UISwitch *)sender {
    
    if (self.clickEventBlock) {
        self.clickEventBlock(sender);
    }
    
}


- (IBAction)messageBook:(UISwitch *)sender {
    if (self.clickEventBlock) {
        self.clickEventBlock(sender);
    }
}


- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.titleLabel.text = model.name;
    
}

- (void)setSmsModifyModel:(BTTSMSEmailModifyModel *)smsModifyModel {
    _smsModifyModel = smsModifyModel;
    if ([self.titleLabel.text isEqualToString:@"余额变更"]) {
        if (_smsModifyModel) {
            if (_smsModifyModel.deposit &&
                _smsModifyModel.withdrawal &&
                _smsModifyModel.promotions) {
                [self.msmSwith setOn:YES];
            } else {
                [self.msmSwith setOn:NO];
            }
        } else {
            [self.msmSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@"资料变更"]) {
        if (_smsModifyModel) {
            if (_smsModifyModel.modify_password &&
                _smsModifyModel.modify_phone &&
                _smsModifyModel.modify_banking_data &&
                _smsModifyModel.modify_account_name) {
                [self.msmSwith setOn:YES];
            } else {
                [self.msmSwith setOn:NO];
            }
        } else {
            [self.msmSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@"网站域名变更"]) {
        if (_smsModifyModel) {
            if (_smsModifyModel.new_website) {
                [self.msmSwith setOn:YES];
            } else {
                [self.msmSwith setOn:NO];
            }
        } else {
            [self.msmSwith setOn:NO];
        }
        
    } else if ([self.titleLabel.text isEqualToString:@"网站收款账号变更"]) {
        if (_smsModifyModel) {
            if (_smsModifyModel.new_payment_account) {
                [self.msmSwith setOn:YES];
            } else {
                [self.msmSwith setOn:NO];
            }
        } else {
            [self.msmSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@"登录提示"]) {
        if (_smsModifyModel) {
            if (_smsModifyModel.login &&
                _smsModifyModel.specific_msg &&
                _smsModifyModel.regards) {
                [self.msmSwith setOn:YES];
            } else {
                [self.msmSwith setOn:NO];
            }
        } else {
            [self.msmSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@"优惠活动通知"]) {
        if (_smsModifyModel) {
            if (_smsModifyModel.notify_promotions) {
                [self.msmSwith setOn:YES];
            } else {
                [self.msmSwith setOn:NO];
            }
        } else {
            [self.msmSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@""]) {
        if (_smsModifyModel) {
            if (_smsModifyModel.deposit &&
                _smsModifyModel.withdrawal &&
                _smsModifyModel.promotions &&
                _smsModifyModel.modify_password &&
                _smsModifyModel.modify_phone &&
                _smsModifyModel.modify_banking_data &&
                _smsModifyModel.modify_account_name &&
                _smsModifyModel.new_website &&
                _smsModifyModel.new_payment_account &&
                _smsModifyModel.login &&
                _smsModifyModel.specific_msg &&
                _smsModifyModel.regards &&
                _smsModifyModel.notify_promotions) {
                [self.msmSwith setOn:YES];
            } else {
                [self.msmSwith setOn:NO];
            }
        } else {
            [self.msmSwith setOn:NO];
        }
    }
}

- (void)setEmailModifyModel:(BTTSMSEmailModifyModel *)emailModifyModel {
    _emailModifyModel = emailModifyModel;
    if ([self.titleLabel.text isEqualToString:@"余额变更"]) {
        if (_emailModifyModel) {
            if (_emailModifyModel.deposit &&
                _emailModifyModel.withdrawal &&
                _emailModifyModel.promotions) {
                [self.emailSwith setOn:YES];
            } else {
                [self.emailSwith setOn:NO];
            }
        } else {
            [self.emailSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@"资料变更"]) {
        if (_emailModifyModel) {
            if (_emailModifyModel.modify_password &&
                _emailModifyModel.modify_phone &&
                _emailModifyModel.modify_banking_data &&
                _emailModifyModel.modify_account_name) {
                [self.emailSwith setOn:YES];
            } else {
                [self.emailSwith setOn:NO];
            }
        } else {
            [self.emailSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@"网站域名变更"]) {
        if (_emailModifyModel) {
            if (_emailModifyModel.new_website) {
                [self.emailSwith setOn:YES];
            } else {
                [self.emailSwith setOn:NO];
            }
        } else {
            [self.emailSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@"网站收款账号变更"]) {
        if (_emailModifyModel) {
            if (_emailModifyModel.new_payment_account) {
                [self.emailSwith setOn:YES];
            } else {
                [self.emailSwith setOn:NO];
            }
        } else {
            [self.emailSwith setOn:NO animated:YES];
        }
    } else if ([self.titleLabel.text isEqualToString:@"登录提示"]) {
        if (_emailModifyModel) {
            if (_emailModifyModel.login &&
                _emailModifyModel.specific_msg &&
                _emailModifyModel.regards) {
                [self.emailSwith setOn:YES];
            } else {
                [self.emailSwith setOn:NO];
            }
        } else {
            [self.emailSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@"优惠活动通知"]) {
        if (_emailModifyModel) {
            if (_emailModifyModel.notify_promotions) {
                [self.emailSwith setOn:YES];
            } else {
                [self.emailSwith setOn:NO];
            }
        } else {
            [self.emailSwith setOn:NO];
        }
    } else if ([self.titleLabel.text isEqualToString:@""]) {
        if (_emailModifyModel) {
            if (_emailModifyModel.deposit &&
                _emailModifyModel.withdrawal &&
                _emailModifyModel.promotions &&
                _emailModifyModel.modify_password &&
                _emailModifyModel.modify_phone &&
                _emailModifyModel.modify_banking_data &&
                _emailModifyModel.modify_account_name &&
                _emailModifyModel.new_website &&
                _emailModifyModel.new_payment_account &&
                _emailModifyModel.login &&
                _emailModifyModel.specific_msg &&
                _emailModifyModel.regards &&
                _emailModifyModel.notify_promotions) {
                [self.emailSwith setOn:YES];
            } else {
                [self.emailSwith setOn:NO];
            }
        } else {
            [self.emailSwith setOn:NO];
        }
    }
    
}

@end
