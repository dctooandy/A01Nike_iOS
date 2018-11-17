//
//  BTTHomePageADCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageADCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BTTPosterModel.h"

@interface BTTHomePageADCell ()

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BTTHomePageADCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
}

- (IBAction)closeBtnClick:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (void)setModel:(BTTPosterModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.logo.path] placeholderImage:ImageNamed(@"")];
}

@end
