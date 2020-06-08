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
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 94, SCREEN_WIDTH-32, 18)];
        imgView.image = [UIImage imageNamed:@"bfb_save_discount"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [infoView addSubview:imgView];
//        
//        UIButton *bindButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 74, SCREEN_WIDTH-32, 44)];
//        [bindButton setTitle:@"一键添加币付宝钱包?" forState:UIControlStateNormal];
//        
//        bindButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [bindButton setTitleColor:COLOR_RGBA(42, 97, 209, 1) forState:UIControlStateNormal];
//        [bindButton addTarget:self action:@selector(bindBtn_click) forControlEvents:UIControlEventTouchUpInside];
//        [infoView addSubview:bindButton];
//        
//        UIButton *downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 118, SCREEN_WIDTH-32, 120)];
//        [downloadBtn setImage:[UIImage imageNamed:@"bfb_banner"] forState:UIControlStateNormal];
//        [downloadBtn addTarget:self action:@selector(downloadBtn_click) forControlEvents:UIControlEventTouchUpInside];
//        [infoView addSubview:downloadBtn];
        
        
    }
    return self;
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
