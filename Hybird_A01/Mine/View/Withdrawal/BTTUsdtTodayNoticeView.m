//
//  BTTUsdtTodayNoticeView.m
//  Hybird_A01
//
//  Created by Levy on 1/15/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTUsdtTodayNoticeView.h"

@implementation BTTUsdtTodayNoticeView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 6;
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.height.mas_equalTo(160);
        make.width.mas_equalTo(SCREEN_WIDTH-72);
    }];
    
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = @"USDT取款赠送1%优惠";
    topLabel.font = [UIFont systemFontOfSize:18];
    topLabel.textColor = [UIColor blackColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(16);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(40);
    }];
    
    CGFloat btnWidth = SCREEN_WIDTH/2-35.5;
    
    UIButton *cancelButton = [[UIButton alloc]init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *confirmButton = [[UIButton alloc]init];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(50);
    }];
    
    CALayer *layer = [CALayer new];
    layer.frame = CGRectMake(0, 115, SCREEN_WIDTH-72, 1);
    layer.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    [contentView.layer addSublayer:layer];
    
    CALayer *bottomLayer = [CALayer new];
    bottomLayer.frame = CGRectMake(btnWidth, 116, 1, 50);
    bottomLayer.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
    [contentView.layer addSublayer:bottomLayer];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = @"详情";
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.textColor = [UIColor blackColor];
    detailLabel.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLabel.mas_bottom);
        make.left.mas_equalTo(topLabel.mas_left);
        make.bottom.mas_equalTo(cancelButton.mas_top);
        make.width.mas_equalTo(btnWidth-20);
    }];
    
    UIButton *contactButton = [[UIButton alloc]init];
    [contactButton setTitle:@"咨询客服" forState:UIControlStateNormal];
    [contactButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    contactButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [contactButton addTarget:self action:@selector(contactCustomerService) forControlEvents:UIControlEventTouchUpInside];
    [self SetUnderLine:contactButton setTitle:@"咨询客服"];
    [contentView addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLabel.mas_bottom);
        make.left.mas_equalTo(detailLabel.mas_right);
        make.width.mas_greaterThanOrEqualTo(10);
        make.bottom.mas_equalTo(cancelButton.mas_top);
    }];
}

- (void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)SetUnderLine:(UIButton*)btn setTitle:(NSString*)title
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]range:strRange];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)contactCustomerService{
    if (_tapContact) {
        _tapContact();
    }
}

- (void)cancelBtn_click:(id)sender{
    if (_tapCancel) {
        _tapCancel();
    }
}

- (void)confirmBtn_click:(id)sender{
    if (_tapConfirm) {
        _tapConfirm();
    }
}

@end
