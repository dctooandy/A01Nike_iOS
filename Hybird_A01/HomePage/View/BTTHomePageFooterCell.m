//
//  BTTHomePageFooterCell.m
//  Hybird_A01
//
//  Created by Domino on 05/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTHomePageFooterCell.h"

#import "BTTPosterModel.h"

@interface BTTHomePageFooterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation BTTHomePageFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (void)setModel:(BTTPosterModel *)model {
    _model = model;
    if (_model) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.logo.path] placeholderImage:ImageNamed(@"default_4")];
    }
}

@end
