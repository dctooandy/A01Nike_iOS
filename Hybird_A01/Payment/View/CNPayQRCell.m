//
//  CNPayQRCell.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/26.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayQRCell.h"

@interface CNPayQRCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tuijianWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@end

@implementation CNPayQRCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {
        self.iconWidth.constant = 28;
        self.iconHeight.constant = 28;
        self.titleLb.font = [UIFont systemFontOfSize:10];
        self.tuijianWidth.constant = 25;
        self.bottom.constant = 7.5;
        self.right.constant = -4.5;
    } else if (SCREEN_WIDTH == 375) {
        self.tuijianWidth.constant = 28;
        self.bottom.constant = 8.5;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.bgIV.image = [UIImage imageNamed:selected ? @"pay_QRSelected": @"pay_QRNormal"];
}

@end
