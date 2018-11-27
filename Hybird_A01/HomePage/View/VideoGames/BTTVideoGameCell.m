//
//  BTTVideoGameCell.m
//  Hybird_A01
//
//  Created by Domino on 27/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGameCell.h"

@interface BTTVideoGameCell ()

@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameIconHeightConstants;

@end

@implementation BTTVideoGameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.gameIconHeightConstants.constant = (SCREEN_WIDTH / 2 - 22.5) / 130 * 90;
}

@end
