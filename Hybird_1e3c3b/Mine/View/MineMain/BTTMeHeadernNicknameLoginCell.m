//
//  BTTMeHeadernNicknameLoginCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 29/04/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTMeHeadernNicknameLoginCell.h"
#import "TXScrollLabelView.h"

@interface BTTMeHeadernNicknameLoginCell ()<TXScrollLabelViewDelegate>

@property (nonatomic, strong) TXScrollLabelView *scrollLabelView;
@property (weak, nonatomic) IBOutlet UILabel *amountTipLabel;

@property (weak, nonatomic) IBOutlet UIView *topBgView;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UIButton *changeModeBtn;

@end

@implementation BTTMeHeadernNicknameLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.vipLevelLabel.layer.cornerRadius = 2;
}

- (IBAction)btnClick:(UIButton *)sender {
    if (_accountBlanceBlock) {
        _accountBlanceBlock();
    }
}

- (void)setNoticeStr:(NSString *)noticeStr {
    _noticeStr = noticeStr;
    if (!_scrollLabelView && noticeStr) {
        _scrollLabelView = [TXScrollLabelView scrollWithTitle:_noticeStr type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
        _scrollLabelView.frame = CGRectMake(40, 3, SCREEN_WIDTH - 55, 25);
        _scrollLabelView.scrollLabelViewDelegate = self;
        _scrollLabelView.tx_centerX  = (SCREEN_WIDTH + 30) * 0.5;
        _scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 15);
        _scrollLabelView.font = [UIFont systemFontOfSize:14];
        _scrollLabelView.scrollTitleColor = [UIColor whiteColor];
        _scrollLabelView.textAlignment = NSTextAlignmentCenter;
        _scrollLabelView.backgroundColor = [UIColor clearColor];
        [self.topBgView addSubview:_scrollLabelView];
        [_scrollLabelView beginScrolling];
    }
}

- (void)setTotalAmount:(NSString *)totalAmount {
    _totalAmount = totalAmount;
    self.amountLabel.text = _totalAmount;
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        self.amountTipLabel.text = @"账户总余额(USDT)";
    }else{
        self.amountTipLabel.text = @"账户总余额(¥)";
    }
}

-(void)setChangModeImgStr:(NSString *)changModeImgStr {
    _changModeImgStr = changModeImgStr;
    [self.changeModeBtn setImage:[UIImage imageNamed:_changModeImgStr] forState:UIControlStateNormal];
    self.changeModeBtn.hidden = [IVNetwork savedUserInfo].uiModeOptions.count <= 1;
    for (int i = 0; i < [IVNetwork savedUserInfo].uiModeOptions.count; i++) {
        NSString * option = [IVNetwork savedUserInfo].uiModeOptions[i];
        if ([IVNetwork savedUserInfo].uiMode != option) {
            self.changeModeBtn.tag = i;
        }
    }
}

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index {
    if (self.clickEventBlock) {
        self.clickEventBlock(text);
    }
}

- (IBAction)changeModeBtn_click:(UIButton *)sender {
    if (self.changModeTap) {
//        self.changModeTap([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"CNY":@"USDT");
        self.changModeTap([IVNetwork savedUserInfo].uiModeOptions[sender.tag]);
    }
}

@end
