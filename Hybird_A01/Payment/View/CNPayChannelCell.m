//
//  CNPayChannelCell.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayChannelCell.h"
#import "CNPayConstant.h"

@interface CNPayChannelCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectedIV;
@property (weak, nonatomic) IBOutlet UIImageView *normalIV;
@end

@implementation CNPayChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedIV.hidden = !selected;
    self.normalIV.hidden = selected;
}

@end
