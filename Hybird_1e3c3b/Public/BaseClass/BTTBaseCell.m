//
//  BTTBaseCell.m
//  A01_Sports
//
//  Created by Domino on 2018/9/25.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCell.h"

@implementation BTTBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = COLOR_RGBA(41, 45, 54, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
