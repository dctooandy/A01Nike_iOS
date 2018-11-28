//
//  BTTMeInfoCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMeInfoCell.h"
#import "BTTMeMainModel.h"

@interface BTTMeInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

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
    if ([model.name isEqualToString:@"个人资料"]) {
        self.iconImg.image = [IVNetwork userInfo].real_name.length ? ImageNamed(model.desc) : ImageNamed(model.iconName);
    } else if ([model.name isEqualToString:@"更换手机"] || [model.name isEqualToString:@"绑定手机"]) {
        self.iconImg.image = [IVNetwork userInfo].isPhoneBinded ? ImageNamed(model.desc) : ImageNamed(model.iconName);
    } else if ([model.name isEqualToString:@"绑定邮箱"]) {
        self.iconImg.image = [IVNetwork userInfo].isEmailBinded ? ImageNamed(model.desc) : ImageNamed(model.iconName);
    } else if ([model.name isEqualToString:@"银行卡资料"]) {
        self.iconImg.image = [IVNetwork userInfo].isBankBinded ? ImageNamed(model.desc) : ImageNamed(model.iconName);
    }
    self.nameLabel.text = model.name;
}

@end
