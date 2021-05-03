//
//  BTTMeHeaderLoginCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMeHeaderLoginCell.h"
#import "TXScrollLabelView.h"

@interface BTTMeHeaderLoginCell ()<TXScrollLabelViewDelegate>

@property (nonatomic, strong) TXScrollLabelView *scrollLabelView;
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIButton *changeModeBtn;

@property (weak, nonatomic) IBOutlet UILabel *amountTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *liCaiTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *liCaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *liCaiPlusLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolPlusLabel;

@end

@implementation BTTMeHeaderLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.vipLevelLabel.layer.cornerRadius = 2;
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
        self.liCaiTipLabel.text = @"活期理财钱包(USDT)";
    }else{
        self.amountTipLabel.text = @"账户总余额(¥)";
        self.liCaiTipLabel.text = @"活期理财钱包(¥)";
    }
}

-(void)setLiCaiAmount:(NSString *)liCaiAmount {
    _liCaiAmount = liCaiAmount;
    self.liCaiLabel.text = _liCaiAmount;
}

-(void)setLiCaiPlusAmount:(NSString *)liCaiPlusAmount {
    _liCaiPlusAmount = liCaiPlusAmount;
    self.liCaiPlusLabel.text = _liCaiPlusAmount;
    if ([self.liCaiPlusAmount floatValue] < 0.01) {
        self.liCaiPlusLabel.hidden = true;
        self.symbolPlusLabel.hidden = true;
    } else {
        self.liCaiPlusLabel.hidden = false;
        self.symbolPlusLabel.hidden = false;
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

- (IBAction)btnClick:(UIButton *)sender {
    if (_accountBlanceBlock) {
        _accountBlanceBlock();
    }
}

- (IBAction)liCaiBtnClick:(UIButton *)sender {
    if (self.liCaiBlock) {
        self.liCaiBlock();
    }
}

- (IBAction)nicknameBtn:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
- (IBAction)changeModeBtn_click:(UIButton *)sender {
    if (self.changModeTap) {
//        self.changModeTap([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"CNY":@"USDT");
        self.changModeTap([IVNetwork savedUserInfo].uiModeOptions[sender.tag]);
    }
}


@end
