//
//  BTTLoginAccountSelectCell.m
//  Hybird_A01
//
//  Created by Domino on 11/02/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTLoginAccountSelectCell.h"

@implementation BTTLoginAccountSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectBtn.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
