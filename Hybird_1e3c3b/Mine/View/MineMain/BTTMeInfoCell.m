//
//  BTTMeInfoCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMeInfoCell.h"
#import "BTTMeMainModel.h"

@interface BTTMeInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstants;
@end

@implementation BTTMeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor =  COLOR_RGBA(36, 40, 49, 1);
    [self setSelectedBackgroundView:backgroundView];
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.iconImg.image = ImageNamed(model.iconName);
    self.nameLabel.text = model.name;
    if ([model.name isEqualToString:@"银行卡资料"] ||
        [model.name isEqualToString:@"绑定手机"] ||
        [model.name isEqualToString:@"个人资料"] ||
        [model.name isEqualToString:@"钱包管理"] ||
        [model.name isEqualToString:@"推荐礼金"]) {
        self.statusIcon.hidden = NO;
        self.topConstants.constant = 0;
        self.rightConstants.constant = 0;
        if ([model.name isEqualToString:@"个人资料"]) {
            if ([IVNetwork savedUserInfo].realName.length) {
                self.statusIcon.image = ImageNamed(@"me_bankcard_status_yes");
            } else {
                self.statusIcon.image = ImageNamed(@"me_bankcard_status_no");
            }
        } else if ([model.name isEqualToString:@"绑定手机"]) {
            if ([IVNetwork savedUserInfo].mobileNoBind==1) {
                self.statusIcon.image = ImageNamed(@"me_phone_status_yes");
            } else {
                self.statusIcon.image = ImageNamed(@"me_phone_status_no");
            }
        } else if ([model.name isEqualToString:@"推荐礼金"]) {
            self.statusIcon.image = ImageNamed(@"me_hot");
            self.topConstants.constant = 10;
            self.rightConstants.constant = 10;
        }
        else {
            if ([IVNetwork savedUserInfo].bankCardNum!=0||[IVNetwork savedUserInfo].usdtNum>0||[IVNetwork savedUserInfo].bfbNum>0) {
               self.statusIcon.image = ImageNamed(@"me_phone_status_yes");
           } else {
               self.statusIcon.image = ImageNamed(@"me_phone_status_no");
           }
        }
    } else {
        self.statusIcon.hidden = YES;
    }
}

@end
