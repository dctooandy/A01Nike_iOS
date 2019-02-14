//
//  BTTLoginAccountSelectCell.m
//  Hybird_A01
//
//  Created by Domino on 11/02/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTLoginAccountSelectCell.h"

@interface BTTLoginAccountSelectCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstants;


@end


@implementation BTTLoginAccountSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectBtn.selected = YES;
    if (SCREEN_WIDTH == 320) {
        self.leftConstants.constant = 40;
        self.accountLabel.font = [UIFont systemFontOfSize:12];
    } else if (SCREEN_WIDTH == 375) {
        self.leftConstants.constant = 50;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
