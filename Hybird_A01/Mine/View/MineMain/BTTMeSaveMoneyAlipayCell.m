//
//  BTTMeSaveMoneyAlipayCell.m
//  Hybird_A01
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
//    self.bfbsendImg.hidden = ![model.name isEqualToString:@"币付宝"];
}

@end
