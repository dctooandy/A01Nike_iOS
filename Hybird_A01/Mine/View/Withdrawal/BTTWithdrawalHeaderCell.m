//
//  BTTWithdrawalHeaderCell.m
//  Hybird_A01
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
//    self.limitLabel.text = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"取款限额:1USDT-143万USDT,全额投注即可申请取款" : @"取款限额:100-1000万RMB,全额投注即可申请取款";
    
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
