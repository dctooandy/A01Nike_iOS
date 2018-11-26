//
//  CNPayChannelCell.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayChannelCell.h"
#import "CNPayConstant.h"

@implementation CNPayChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.channelBtn.selected = selected;
    self.titleLb.textColor = selected ? COLOR_HEX(0x3C3C3C): COLOR_HEX(0x8B8B8B);
}

@end
