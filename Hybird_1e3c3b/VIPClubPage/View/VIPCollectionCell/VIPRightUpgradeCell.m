//
//  VIPRightUpgradeCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/12.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "VIPRightUpgradeCell.h"

@implementation VIPRightUpgradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor clearColor];
    // Initialization code
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.cellImageView.layer setMasksToBounds:NO];
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    if (selected == YES)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.transform = CGAffineTransformScale(self.transform, 1.3f, 1.3f);
//        }];
//    }else
//    {
//        self.transform = CGAffineTransformIdentity;
//    }
}

@end
