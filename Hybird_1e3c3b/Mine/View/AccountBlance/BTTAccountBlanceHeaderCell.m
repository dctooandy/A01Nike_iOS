//
//  BTTAccountBlanceHeaderCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTAccountBlanceHeaderCell.h"
#import "BTTLockButtonView.h"
#import "BTTUserForzenManager.h"

@interface BTTAccountBlanceHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *topTipLabel;
@property (weak, nonatomic) IBOutlet UIView *lockView;

@end

@implementation BTTAccountBlanceHeaderCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.trasferToLocal.enabled = YES;
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        self.topTipLabel.text = @"总余额(USDT)";
    }else{
        self.topTipLabel.text = @"总余额(元)";
    }
    [self setupIconview];
}

- (void)setupIconview
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
    if (UserForzenStatus)
    {
        _lockView.hidden = NO;
    }else
    {
        _lockView.hidden = YES;
    }
}
- (IBAction)totalBtnClick:(UIButton *)sender {
    if (UserForzenStatus)
    {
        if ([IVNetwork savedUserInfo]) {
            [[BTTUserForzenManager sharedInstance] checkUserForzen];
        }
    }else
    {
        if (self.buttonClickBlock) {
            self.buttonClickBlock(sender);
        }        
    }
}

@end
