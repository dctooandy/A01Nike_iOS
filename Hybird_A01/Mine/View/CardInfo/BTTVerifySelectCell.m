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

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation BTTVerifySelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.layer.cornerRadius = 2;
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.iconImage.image = ImageNamed(model.iconName);
    self.nameLabel.text = model.name;
    self.detailLabel.text = model.desc;
    if ([model.name isEqualToString:@"通过短信验证"]) {
        self.label.hidden = NO;
    } else {
        self.label.hidden = YES;
    }
}

@end
