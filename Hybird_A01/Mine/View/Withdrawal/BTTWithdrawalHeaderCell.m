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
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;


@end

@implementation BTTWithdrawalHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tipLabel.text = [IVNetwork savedUserInfo].newAccountFlag==1 ? @"可取金额(USDT)" : @"可取金额(元)";
    self.limitLabel.text = [IVNetwork savedUserInfo].newAccountFlag==1 ? @"取款限额:1USDT-1000万USDT,未享受优惠全额投注即可取款" : @"取款限额:10-1000万RMB,未享受优惠全额投注即可取款";
    
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
