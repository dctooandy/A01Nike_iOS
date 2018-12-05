//
//  BTTMeHeaderLoginCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMeHeaderLoginCell.h"
#import <TXScrollLabelView/TXScrollLabelView.h>

@interface BTTMeHeaderLoginCell ()<TXScrollLabelViewDelegate>

@property (nonatomic, strong) TXScrollLabelView *scrollLabelView;

@property (weak, nonatomic) IBOutlet UIView *topBgView;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;



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
@end
