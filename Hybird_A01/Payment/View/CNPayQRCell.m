//
//  CNPayQRCell.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/26.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayQRCell.h"

@implementation CNPayQRCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.bgIV.image = [UIImage imageNamed:selected ? @"pay_QRSelected": @"pay_QRNormal"];
}

@end
