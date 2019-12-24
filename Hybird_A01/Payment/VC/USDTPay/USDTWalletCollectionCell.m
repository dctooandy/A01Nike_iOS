//
//  USDTWalletCollectionCell.m
//  Hybird_A01
//
//  Created by Levy on 12/24/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "USDTWalletCollectionCell.h"

@implementation USDTWalletCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.cornerRadius = 8.0;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
}

-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.contentView.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
    }else{
        self.contentView.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    }
}

@end
