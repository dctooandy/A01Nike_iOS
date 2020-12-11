//
//  BTTWithdrawalHeaderCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalHeaderCell.h"

@interface BTTWithdrawalHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *totalAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation BTTWithdrawalHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tipLabel.text = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"可取金额(USDT)" : @"可取金额(元)";
}

- (void)setTotalAvailable:(NSString *)totalAvailable {
    _totalAvailable = totalAvailable;
    self.totalAvailableLabel.text = _totalAvailable;
}

- (IBAction)blanceBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
