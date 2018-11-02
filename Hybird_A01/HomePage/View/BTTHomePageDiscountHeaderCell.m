//
//  BTTHomePageDiscountHeaderCell.m
//  Hybird_A01
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

@property (strong, nonatomic) UIImageView *arrowIcon;

@end

@implementation BTTHomePageDiscountHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.arrowIcon.hidden = YES;
    self.arrowIcon = [UIImageView new];
    self.arrowIcon.image = ImageNamed(@"homepage_arrow");
    [self.contentView addSubview:self.arrowIcon];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
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
        self.arrowIcon.hidden = NO;
    } else {
        self.arrowIcon.hidden = YES;
    }
}

@end
