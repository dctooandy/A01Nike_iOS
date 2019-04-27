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

- (void)setCellBtnType:(BTTBtnCellType)cellBtnType {
    _cellBtnType = cellBtnType;
    if (_cellBtnType == BTTBtnCellTypeLogin) {
        [self.loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    } else if (_cellBtnType == BTTBtnCellTypeGetGameAccount) {
        [self.loginBtn setTitle:@"点击获取游戏账号" forState:UIControlStateNormal];
    }
    else {
        [self.loginBtn setTitle:@"立即开户" forState:UIControlStateNormal];
    }
}


- (IBAction)loginBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


@end
