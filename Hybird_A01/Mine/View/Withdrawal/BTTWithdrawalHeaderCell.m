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


@end

@implementation BTTWithdrawalHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setTotalAvailable:(NSString *)totalAvailable {
    _totalAvailable = totalAvailable;
    self.totalAvailableLabel.text = _totalAvailable;
}

- (IBAction)blanceBtnClick:(UIButton *)sender {
}

@end
