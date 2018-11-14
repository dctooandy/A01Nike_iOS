//
//  BTTLoginOrRegisterTypeSelectCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterTypeSelectCell.h"

@interface BTTLoginOrRegisterTypeSelectCell ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIImageView *loginIcon;

@property (weak, nonatomic) IBOutlet UIImageView *registerIcon;

@end

@implementation BTTLoginOrRegisterTypeSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.loginIcon.hidden = NO;
    self.registerIcon.hidden = YES;
}


- (IBAction)loginBtnClick:(UIButton *)sender {
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor colorWithHexString:@"818791"] forState:UIControlStateNormal];
    self.loginIcon.hidden = NO;
    self.registerIcon.hidden = YES;
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


- (IBAction)registerBtnClick:(UIButton *)sender {
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"818791"] forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginIcon.hidden = YES;
    self.registerIcon.hidden = NO;
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


@end
