//
//  BTTAddCardBtnsCell.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddCardBtnsCell.h"

@implementation BTTAddCardBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}
- (IBAction)save:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
