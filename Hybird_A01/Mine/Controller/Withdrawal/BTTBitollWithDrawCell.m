//
//  BTTBitollWithDrawCell.m
//  Hybird_A01
//
//  Created by Flynn on 2020/5/15.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBitollWithDrawCell.h"
#import "CNPayConstant.h"

@interface BTTBitollWithDrawCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *onekeyBtn;
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) UIButton *onekeySellBtn;
@end

@implementation BTTBitollWithDrawCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    if (self) {
        self.contentView.backgroundColor = kBlackBackgroundColor;
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        infoView.backgroundColor = kBlackBackgroundColor;
        [self.contentView addSubview:infoView];
        
        UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 20, SCREEN_WIDTH-32, 44)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.enabled = NO;
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"binding_confirm_enable_normal"] forState:UIControlStateNormal];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"binding_confirm_disable"] forState:UIControlStateDisabled];
        
        [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        confirmBtn.layer.cornerRadius = 4.0;
        confirmBtn.clipsToBounds = YES;
        [confirmBtn addTarget:self action:@selector(confirmBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:confirmBtn];
        _confirmBtn = confirmBtn;
        
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 94, SCREEN_WIDTH-32, 18)];
//        imgView.image = [UIImage imageNamed:@"bfb_take_note"];
//        imgView.contentMode = UIViewContentModeScaleAspectFit;
//        imgView.hidden = YES;
//        [infoView addSubview:imgView];
//        _imgView = imgView;
        
        NSString *str = @"取款USDT到帐后,可一键卖币提现至银行卡";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attrStr addAttribute:NSForegroundColorAttributeName
        value:[UIColor whiteColor]
                        range:NSMakeRange(0, str.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName
        value:[UIColor yellowColor]
        range:NSMakeRange(11, 4)];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(11, 4)];
        
        UIButton *oneKeySellBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 74, SCREEN_WIDTH-32, 44)];
        [oneKeySellBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        
        oneKeySellBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [oneKeySellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [oneKeySellBtn addTarget:self action:@selector(oneKeySellUsdt_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:oneKeySellBtn];
        _onekeySellBtn = oneKeySellBtn;
        
        
//        UIButton *bindButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 74, SCREEN_WIDTH-32, 44)];
//        [bindButton setTitle:@"一键添加币付宝钱包?" forState:UIControlStateNormal];
//
//        bindButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [bindButton setTitleColor:COLOR_HEX(0x2497FF) forState:UIControlStateNormal];
//        [bindButton addTarget:self action:@selector(bindBtn_click) forControlEvents:UIControlEventTouchUpInside];
//        [infoView addSubview:bindButton];
//        _onekeyBtn = bindButton;
        
        
        
//        UIButton *downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 118, SCREEN_WIDTH-32, 120)];
//        [downloadBtn setImage:[UIImage imageNamed:@"bfb_banner"] forState:UIControlStateNormal];
//        [downloadBtn addTarget:self action:@selector(downloadBtn_click) forControlEvents:UIControlEventTouchUpInside];
//        [infoView addSubview:downloadBtn];
//        _downloadBtn = downloadBtn;
        
        
    }
    return self;
}

- (void)setImageViewHidden:(BOOL)imgHidden onekeyHidden:(BOOL)onekeyHidden sellHidden:(BOOL)sellHidden{
    self.imgView.hidden = YES;
    self.onekeyBtn.hidden = YES;
    self.downloadBtn.hidden = YES;
    self.onekeySellBtn.hidden = !sellHidden;
}

- (void)oneKeySellUsdt_click{
    if (self.oneKeySell) {
        self.oneKeySell();
    }
}

- (void)confirmBtn_click{
    if (self.confirmTap) {
        self.confirmTap();
    }
}

- (void)bindBtn_click{
    if (self.bindTap) {
        self.bindTap();
    }
}

- (void)downloadBtn_click{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.bitoll.com/ios.html"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
