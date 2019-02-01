//
//  BTTMeSaveMoneyCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMeSaveMoneyCell.h"
#import "BTTMeMainModel.h"

@interface BTTMeSaveMoneyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstants;

@end

@implementation BTTMeSaveMoneyCell

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
    if ([model.name isEqualToString:@"银行快捷网银"] ||
        [model.name isEqualToString:@"点卡"] ||
        [model.name isEqualToString:@"钻石币"] ||
        [model.name isEqualToString:@"比特币"] ||
        [model.name isEqualToString:@"微信条码支付"]) {
        self.topConstants.constant = 20;
        self.heightConstants.constant = 30;
        self.widthConstants.constant = 30;
    } else  {
        self.topConstants.constant = 15;
        self.heightConstants.constant = 40;
        self.widthConstants.constant = 40;
    }
}

@end
