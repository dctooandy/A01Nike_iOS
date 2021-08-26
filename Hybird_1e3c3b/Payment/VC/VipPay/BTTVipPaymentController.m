//
//  BTTVipPaymentController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/17/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVipPaymentController.h"

@interface BTTVipPaymentController ()

@end

@implementation BTTVipPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewHeight:450 fullScreen:NO];
    UILabel * lab = [[UILabel alloc]init];
    lab.text = @"存款信息";
    lab.font = [UIFont systemFontOfSize:20];
    lab.textColor = [UIColor whiteColor];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(15);
        make.left.right.equalTo(lab);
        make.height.offset(1);
    }];
    
    UIImage * titleImg = [UIImage imageNamed:@"ic_vippay_title"];
    UIImageView * title = [[UIImageView alloc] initWithImage:titleImg];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.height.offset(titleImg.size.height);
    }];
    
    lab = [[UILabel alloc]init];
    lab.text = @"专员全程为您保驾护航，存款成功率100%";
    lab.textColor = [UIColor darkGrayColor];
    lab.adjustsFontSizeToFitWidth = true;
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.width.offset(titleImg.size.width);
    }];
    
    UIImage * logoImg = [UIImage imageNamed:@"ic_vippay_logo"];
    UIImageView * logo = [[UIImageView alloc] initWithImage:logoImg];
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.height.offset(logoImg.size.height);
    }];
    
    UIButton * btn = [[UIButton alloc] init];
    [btn setTitle:@"联系专员" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"binding_confirm_enable_normal"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(kefu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo.mas_bottom).offset(15);
        make.left.right.equalTo(line);
        make.height.offset(50);
    }];
}

-(void)kefu {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoVIPKefu" object:nil];
}

@end
