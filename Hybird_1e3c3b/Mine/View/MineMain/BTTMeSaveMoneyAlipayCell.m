//
//  BTTMeSaveMoneyAlipayCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 26/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMeSaveMoneyAlipayCell.h"
#import "BTTMeMainModel.h"

@interface BTTMeSaveMoneyAlipayCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bfbsendImg;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;


@end

@implementation BTTMeSaveMoneyAlipayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}


- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.iconImageView.image = ImageNamed(model.iconName);
    self.nameLabel.text = model.name;
//    self.bfbsendImg.hidden = ![model.name isEqualToString:@"充值/购买USDT"];
    self.subTitleLab.text = model.desc;
}

@end
