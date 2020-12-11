//
//  BTTHomePageDiscountHeaderCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageDiscountHeaderCell.h"
#import "BTTHomePageHeaderModel.h"
#import <Masonry/Masonry.h>

@interface BTTHomePageDiscountHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) UIImageView *ArrowIcon;

@end

@implementation BTTHomePageDiscountHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.ArrowIcon.hidden = YES;
    self.ArrowIcon = [UIImageView new];
    self.ArrowIcon.image = ImageNamed(@"homepage_arrow");
    [self.contentView addSubview:self.arrowIcon];
    [self.ArrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.width.equalTo(@16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    
}

- (void)setHeaderModel:(BTTHomePageHeaderModel *)headerModel {
    _headerModel = headerModel;
    self.titleLabel.text = headerModel.titleStr;
    [self.nextBtn setTitle:headerModel.detailBtnStr forState:UIControlStateNormal];
    if (headerModel.detailBtnStr.length) {
        self.ArrowIcon.hidden = NO;
    } else {
        self.ArrowIcon.hidden = YES;
    }
}

@end
