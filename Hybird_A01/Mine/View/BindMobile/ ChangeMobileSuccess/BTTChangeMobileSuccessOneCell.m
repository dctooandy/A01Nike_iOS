//
//  BTTChangeMobileSuccessOneCell.m
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTChangeMobileSuccessOneCell.h"
@interface BTTChangeMobileSuccessOneCell()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *notifyLabel;
@end
@implementation BTTChangeMobileSuccessOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
}
- (void)setMobileCodeType:(BTTSafeVerifyType)mobileCodeType
{
    _mobileCodeType = mobileCodeType;
    switch (mobileCodeType) {
        case BTTSafeVerifyTypeNormalAddBankCard:
        case BTTSafeVerifyTypeNormalAddBTCard:
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileBindAddBankCard:
        case BTTSafeVerifyTypeMobileAddBTCard:
        case BTTSafeVerifyTypeMobileBindAddBTCard:
            self.statusLabel.text = @"添加成功!";
            self.notifyLabel.hidden = YES;
            break;
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileBindChangeBankCard:
        case BTTSafeVerifyTypeChangeMobile:
        case BTTSafeVerifyTypeChangeEmail:
            self.statusLabel.text = @"修改成功!";
            self.notifyLabel.hidden = YES;
            break;
        case BTTSafeVerifyTypeMobileDelBankCard:
        case BTTSafeVerifyTypeMobileBindDelBankCard:
        case BTTSafeVerifyTypeMobileDelBTCard:
        case BTTSafeVerifyTypeMobileBindDelBTCard:
            self.statusLabel.text = @"删除成功!";
            self.notifyLabel.hidden = YES;
            break;
        case BTTSafeVerifyTypeBindMobile:
            self.statusLabel.text = [NSString stringWithFormat:@"已绑定手机号码:%@",self.mobileNo];
            self.notifyLabel.hidden = YES;
            break;
        case BTTSafeVerifyTypeBindEmail:
             self.statusLabel.text = [NSString stringWithFormat:@"已绑定邮箱地址:%@",self.email];
            self.notifyLabel.hidden = YES;
            break;
        case BTTSafeVerifyTypeHumanAddBankCard:
        case BTTSafeVerifyTypeHumanChangeBankCard:
        case BTTSafeVerifyTypeHumanDelBankCard:
        case BTTSafeVerifyTypeHumanAddBTCard:
        case BTTSafeVerifyTypeHumanDelBTCard:
        case BTTSafeVerifyTypeHumanChangeMoblie:
            self.statusLabel.text = @"申请已提交";
            self.notifyLabel.hidden = NO;
            break;
        default:
            self.statusLabel.text = @"处理成功!";
            self.notifyLabel.hidden = YES;
            break;
    }
}


@end
