//
//  BTTHomePageFooterCell.m
//  Hybird_A01
//
//  Created by Domino on 05/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTHomePageFooterCell.h"

@implementation BTTHomePageFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

@end
