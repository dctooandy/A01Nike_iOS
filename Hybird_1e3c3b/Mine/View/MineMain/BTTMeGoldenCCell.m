//
//  BTTMeGoldenCCell.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/22/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "BTTMeGoldenCCell.h"

@implementation BTTMeGoldenCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)btnAction:(UIButton *)sender {
    !_clickAction ?: _clickAction(sender.tag);
}


@end
