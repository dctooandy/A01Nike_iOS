//
//  BTTMeSaveMoneyWechatCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 26/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMeSaveMoneyWechatCell.h"
#import "BTTMeMainModel.h"

@interface BTTMeSaveMoneyWechatCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bfbsendImg;


@end

@implementation BTTMeSaveMoneyWechatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.iconImageView.image = ImageNamed(model.iconName);
    self.nameLabel.text = model.name;
//    self.bfbsendImg.hidden = ![model.name isEqualToString:@"币付宝"];
}

@end
