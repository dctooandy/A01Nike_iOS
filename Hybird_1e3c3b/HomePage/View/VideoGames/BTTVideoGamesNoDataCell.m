//
//  BTTVideoGamesNoDataCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 28/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesNoDataCell.h"

@implementation BTTVideoGamesNoDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

@end
