//
//  BTTVideoGamesNoDataCell.m
//  Hybird_A01
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
