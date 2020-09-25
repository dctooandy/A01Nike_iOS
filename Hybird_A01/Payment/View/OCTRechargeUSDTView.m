//
//  OCTRechargeUSDTView.m
//  Hybird_A01
//
//  Created by Jairo on 12/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "OCTRechargeUSDTView.h"

@interface OCTRechargeUSDTView()

@end

@implementation OCTRechargeUSDTView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI {
    UIView *rechargeView = [[UIView alloc]init];
    rechargeView.backgroundColor = [UIColor colorWithHexString:@"#292d36"];;
    [self addSubview:rechargeView];
    self.rechargeView = rechargeView;
    [self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
    
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = @"选择支付协议";
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textColor = [UIColor whiteColor];
    [self.rechargeView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.rechargeView).offset(16);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.rechargeView);
    }];
    
    UIButton *ercBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 48, 100, 30)];
    [ercBtn setTitle:@"ERC20" forState:UIControlStateNormal];
    ercBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ercBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ercBtn.layer.cornerRadius = 4.0;
    ercBtn.clipsToBounds = YES;
    ercBtn.layer.borderWidth = 0.5;
    ercBtn.layer.borderColor = [UIColor colorWithHexString:@"#2d83cd"].CGColor;
    [self.rechargeView addSubview:ercBtn];
    self.ercBtn = ercBtn;
    
    UIButton *omniBtn = [[UIButton alloc]initWithFrame:CGRectMake(132, 48, 100, 30)];
    [omniBtn setTitle:@"OMNI" forState:UIControlStateNormal];
    omniBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [omniBtn setTitleColor:[UIColor colorWithHexString:@"#6d737c"] forState:UIControlStateNormal];
    omniBtn.layer.cornerRadius = 4.0;
    omniBtn.clipsToBounds = YES;
    omniBtn.layer.borderWidth = 0.5;
    omniBtn.layer.borderColor = [UIColor colorWithHexString:@"#6d737c"].CGColor;
    [self.rechargeView addSubview:omniBtn];
    self.omniBtn = omniBtn;
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"请慎重选择协议类型,若协议类型错误则款项无法到账";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    [self.rechargeView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rechargeView).offset(16);
        make.top.mas_equalTo(self.ercBtn.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.rechargeView).offset(-16);
    }];
    
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#22222a"];
    [self.rechargeView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.rechargeView);
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *rechargeTipLabel = [[UILabel alloc]init];
    rechargeTipLabel.text = @"最低充值 1 USDT,无需填写充值金额,\n充值成功后款项将自动添加到账";
    rechargeTipLabel.numberOfLines = 2;
    rechargeTipLabel.textAlignment = NSTextAlignmentCenter;
    rechargeTipLabel.font = [UIFont systemFontOfSize:12];
    rechargeTipLabel.textColor = [UIColor whiteColor];
    [self.rechargeView addSubview:rechargeTipLabel];
    [rechargeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rechargeView).offset(16);
        make.top.mas_equalTo(sepView.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.rechargeView).offset(-16);
    }];
    
    UIButton *commitBtn = [[UIButton alloc]init];
    [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitBtn setTitle:@"充值完成" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    commitBtn.layer.cornerRadius = 4;
    commitBtn.backgroundColor = COLOR_RGBA(241, 216, 52, 1);
    [self.rechargeView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.rechargeView.mas_bottom).offset(-60);
        make.left.mas_equalTo(self.rechargeView).offset(16);
        make.right.mas_equalTo(self.rechargeView).offset(-16);
        make.height.mas_equalTo(45);
    }];
    self.commitBtn = commitBtn;
    
    UILabel *rateLabel = [[UILabel alloc]init];
    rateLabel.text = @"当前参考汇率 1USDT=7.20元,请以实际汇率为准.";
    rateLabel.numberOfLines = 2;
    rateLabel.textAlignment = NSTextAlignmentCenter;
    rateLabel.font = [UIFont systemFontOfSize:12];
    rateLabel.textColor = [UIColor colorWithHexString:@"#818791"];
    [self.rechargeView addSubview:rateLabel];
    self.rateLabel = rateLabel;
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rechargeView).offset(16);
        make.bottom.mas_equalTo(commitBtn.mas_top).offset(-20);
        make.height.mas_greaterThanOrEqualTo(20);
        make.right.mas_equalTo(self.rechargeView).offset(-16);
    }];
    
    UIImageView *qrCodeView = [[UIImageView alloc]init];
    qrCodeView.image = [PublicMethod QRCodeMethod:@""];
    qrCodeView.contentMode = UIViewContentModeScaleAspectFit;
    [self.rechargeView addSubview:qrCodeView];
    self.qrcodeImg = qrCodeView;
    [qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rechargeTipLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(rateLabel.mas_top).offset(-20);
        make.left.right.mas_equalTo(self.rechargeView);
    }];
}

@end
