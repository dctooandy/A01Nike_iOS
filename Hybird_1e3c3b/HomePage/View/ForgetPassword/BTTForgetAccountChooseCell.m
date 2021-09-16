//
//  BTTForgetAccountChooseCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/17/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetAccountChooseCell.h"

@interface BTTForgetAccountChooseCell()

@property (weak, nonatomic) IBOutlet UILabel *accountNameLab;
@property (weak, nonatomic) IBOutlet UIView *correct_d;

@end

@implementation BTTForgetAccountChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.correct_d.clipsToBounds = true;
    self.correct_d.layer.borderColor = [UIColor whiteColor].CGColor;
    self.correct_d.layer.borderWidth = 1.0;
}

-(void)setAccountNameStr:(NSString *)accountNameStr {
    _accountNameStr = accountNameStr;
    self.accountNameLab.text = _accountNameStr;
}

-(void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.correct_s.hidden = !isSelect;
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.chooseBtnClickBlock) {
        self.chooseBtnClickBlock(sender, !self.correct_s.hidden ? @"":_accountNameStr);
    }
}

@end
