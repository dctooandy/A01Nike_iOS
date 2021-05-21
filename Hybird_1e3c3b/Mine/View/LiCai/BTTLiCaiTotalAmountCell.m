//
//  BTTLiCaiTotalAmountCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/26/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiTotalAmountCell.h"

@interface BTTLiCaiTotalAmountCell()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *earnTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *earnLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestRateLebel;
@end

@implementation BTTLiCaiTotalAmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        self.tipLabel.text = @"額度(USDT)";
        self.earnTipLabel.text = @"額度(USDT)";
    } else {
        self.tipLabel.text = @"額度(¥)";
        self.earnTipLabel.text = @"額度(¥)";
    }
}

-(void)setWalletAmount:(NSString *)walletAmount {
    _walletAmount = walletAmount;
    self.walletAmountLabel.text = _walletAmount;
}

-(void)setEarn:(NSString *)earn {
    _earn = earn;
    self.earnLabel.text = _earn;
}

-(void)setInterestRate:(NSString *)interestRate {
    _interestRate = interestRate;
    self.interestRateLebel.text = _interestRate;
}

- (IBAction)recordBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
