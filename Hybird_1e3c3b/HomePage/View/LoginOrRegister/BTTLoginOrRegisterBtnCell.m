//
//  BTTLoginOrRegisterBtnCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterBtnCell.h"

@interface BTTLoginOrRegisterBtnCell ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (weak, nonatomic) IBOutlet UIButton *quickRegisterBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstants;

@end

@implementation BTTLoginOrRegisterBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"极速开户"];
    
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"499BF7"]  range:NSMakeRange(0,[tncString length])];
    [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHexString:@"499BF7"] range:(NSRange){0,[tncString length]}];
    [self.quickRegisterBtn setAttributedTitle:tncString forState:UIControlStateNormal];
}

- (void)setCellBtnType:(BTTBtnCellType)cellBtnType {
    _cellBtnType = cellBtnType;
    if (_cellBtnType == BTTBtnCellTypeLogin) {
        [self.loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        self.noticeLabel.hidden = YES;
        self.quickRegisterBtn.hidden = YES;
        self.centerConstants.constant = 0;
    } else if (_cellBtnType == BTTBtnCellTypeGetGameAccount) {
        [self.loginBtn setTitle:@"点击获取游戏账号" forState:UIControlStateNormal];
        self.noticeLabel.hidden = NO;
        self.quickRegisterBtn.hidden = NO;
        self.centerConstants.constant = -15;
        
    } else {
        [self.loginBtn setTitle:@"立即开户" forState:UIControlStateNormal];
        self.noticeLabel.hidden = YES;
        self.quickRegisterBtn.hidden = YES;
        self.centerConstants.constant = 0;
    }
}


- (IBAction)loginBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)quickRegisterBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
