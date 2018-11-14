//
//  BTTLoginOrRegisterBtnCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterBtnCell.h"

@interface BTTLoginOrRegisterBtnCell ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation BTTLoginOrRegisterBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}


- (IBAction)loginBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


@end
