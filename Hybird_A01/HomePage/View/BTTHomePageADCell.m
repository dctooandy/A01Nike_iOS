//
//  BTTHomePageADCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageADCell.h"
#import "BTTPosterModel.h"

#define BTTImageDefaultWidth  390
#define BTTImageDefaultHeight 45

@interface BTTHomePageADCell ()

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@end

@implementation BTTHomePageADCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
//    if (SCREEN_WIDTH > 414) {
//        self.imageWidth.constant = BTTImageDefaultWidth;
//        self.imageHeight.constant =  BTTImageDefaultHeight;
//    } else {
//        self.imageWidth.constant = SCREEN_WIDTH - 45;
//        self.imageHeight.constant =   (SCREEN_WIDTH - 45) / BTTImageDefaultWidth * BTTImageDefaultHeight;
//    }
    
  
}

- (IBAction)closeBtnClick:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (void)setModel:(BTTPosterModel *)model {
    _model = model;
    if (model) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.logo.path] placeholderImage:ImageNamed(@"default_4")];
    }
}

@end
