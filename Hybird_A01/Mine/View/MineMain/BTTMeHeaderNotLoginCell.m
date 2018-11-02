//
//  BTTMeHeaderNotLoginCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMeHeaderNotLoginCell.h"
#import <TXScrollLabelView/TXScrollLabelView.h>

@interface BTTMeHeaderNotLoginCell ()<TXScrollLabelViewDelegate>

@property (nonatomic, strong) TXScrollLabelView *scrollLabelView;

@property (weak, nonatomic) IBOutlet UIView *topBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginHeightConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginWidthConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerHeightConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerWidthConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCenterConstants;
@end

@implementation BTTMeHeaderNotLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    if (SCREEN_WIDTH == 375) {
        self.loginWidthConstants.constant *= 1.25;
        self.loginHeightConstants.constant *= 1.25;
        self.registerWidthConstants.constant *= 1.25;
        self.registerHeightConstants.constant *= 1.25;
    } else if (SCREEN_WIDTH == 414) {
        self.loginWidthConstants.constant *= 1.5;
        self.loginHeightConstants.constant *= 1.5;
        self.registerWidthConstants.constant *= 1.5;
        self.registerHeightConstants.constant *= 1.5;
    }
    self.btnCenterConstants.constant = -(self.loginWidthConstants.constant / 2 + 7.5);
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

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index {
    
}

- (IBAction)loginClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


@end
