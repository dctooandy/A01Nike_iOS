//
//  BTTVerifySelectCell.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVerifySelectCell.h"
#import "BTTMeMainModel.h"

@interface BTTVerifySelectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation BTTVerifySelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.iconImage.image = ImageNamed(model.iconName);
    self.nameLabel.text = model.name;
    self.detailLabel.text = model.desc;
    if ([model.name isEqualToString:@"通过短信验证"]) {
        self.mineSparaterType = BTTMineSparaterTypeSingleLine;
    } else {
        self.mineSparaterType = BTTMineSparaterTypeNone;
    }
}

@end
