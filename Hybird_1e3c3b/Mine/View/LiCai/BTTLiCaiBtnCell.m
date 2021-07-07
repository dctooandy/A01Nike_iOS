//
//  BTTLiCaiBtnCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/26/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiBtnCell.h"
#import "BTTUserForzenManager.h"
@interface BTTLiCaiBtnCell()

@end

@implementation BTTLiCaiBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor clearColor];
}

- (IBAction)btnClick:(UIButton *)sender {
    if (UserForzenStatus)
    {
        [[BTTUserForzenManager sharedInstance] checkUserForzen];
    }else
    {
        if (self.buttonClickBlock) {
            self.buttonClickBlock(sender);        
        }
    }
}

@end
