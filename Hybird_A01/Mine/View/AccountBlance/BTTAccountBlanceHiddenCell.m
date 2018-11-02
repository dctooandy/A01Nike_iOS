//
//  BTTAccountBlanceHiddenCell.m
//  Hybird_A01
//
//  Created by Domino on 22/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAccountBlanceHiddenCell.h"

@implementation BTTAccountBlanceHiddenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"272c3a"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

@end
