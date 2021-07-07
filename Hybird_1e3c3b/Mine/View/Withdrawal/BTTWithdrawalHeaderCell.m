//
//  BTTWithdrawalHeaderCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalHeaderCell.h"
#import "BTTLockButtonView.h"
#import "BTTUserForzenManager.h"
@interface BTTWithdrawalHeaderCell ()

@property (weak, nonatomic) IBOutlet BTTLockButtonView *lockView;
@property (weak, nonatomic) IBOutlet UILabel *totalAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation BTTWithdrawalHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupLockButtonView];
    self.tipLabel.text = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"可取金额(USDT)" : @"可取金额(元)";
}
- (void)setupLockButtonView
{
    BTTLockButtonView * btnView = [BTTLockButtonView viewFromXib];
    [_lockView addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    btnView.tapLock = ^{
        if ([IVNetwork savedUserInfo]) {
            [[BTTUserForzenManager sharedInstance] checkUserForzen];
        }
    };
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if ([IVNetwork savedUserInfo] && [IVNetwork savedUserInfo].lockBalanceStatus == 1)
    {
        _lockView.hidden = NO;
    }else
    {
        _lockView.hidden = YES;
    }
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
