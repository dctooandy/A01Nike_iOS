//
//  BTTWithDrawUSDTConfirmCell.m
//  Hybird_A01
//
//  Created by Levy on 12/25/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTWithDrawUSDTConfirmCell.h"

@interface BTTWithDrawUSDTConfirmCell()
@property (nonatomic, strong) UILabel *ratelabel;
@property (nonatomic, strong) UIButton *changeTypeBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation BTTWithDrawUSDTConfirmCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    if (self) {
        UILabel *rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 220, 12)];
        rateLabel.font = [UIFont systemFontOfSize:12.0];
        rateLabel.textColor = COLOR_RGBA(129, 135, 145, 1);
        rateLabel.text = @"（当前参考汇率：1RMB= 0.142USDT）";
        [self.contentView addSubview:rateLabel];
        _ratelabel = rateLabel;
        
        UIButton *changeTypeBtn = [[UIButton alloc]init];
        changeTypeBtn.frame = CGRectMake(SCREEN_WIDTH-100, 0, 85, 45);
        changeTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [changeTypeBtn setTitleColor:COLOR_RGBA(219, 189, 133, 1) forState:UIControlStateNormal];
        [changeTypeBtn setImage:[UIImage imageNamed:@"withDraw_switch"] forState:0];
        [changeTypeBtn setTitle:@" 按数量取款" forState:0];
        [changeTypeBtn setTitleColor:[UIColor whiteColor] forState:0];
        [changeTypeBtn addTarget:self action:@selector(changeTypeBtn_click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:changeTypeBtn];
        _changeTypeBtn = changeTypeBtn;
        
        UIButton *confirmBtn = [[UIButton alloc]init];
        confirmBtn.frame = CGRectMake(15, 52, SCREEN_WIDTH-30, 44);
        
        confirmBtn.layer.cornerRadius = 5;
        confirmBtn.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
        confirmBtn.alpha = 1;

        //Gradient 0 fill for 圆角矩形 11
        CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
        gradientLayer0.cornerRadius = 5;
        gradientLayer0.frame = confirmBtn.bounds;
        gradientLayer0.colors = @[
            (id)[UIColor colorWithRed:247.0f/255.0f green:249.0f/255.0f blue:82.0f/255.0f alpha:1.0f].CGColor,
            (id)[UIColor colorWithRed:242.0f/255.0f green:218.0f/255.0f blue:15.0f/255.0f alpha:1.0f].CGColor];
        gradientLayer0.locations = @[@0, @1];
        [gradientLayer0 setStartPoint:CGPointMake(1, 1)];
        [gradientLayer0 setEndPoint:CGPointMake(0, 0)];
        [confirmBtn.layer addSublayer:gradientLayer0];
        
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [confirmBtn setTitleColor:COLOR_RGBA(33, 34, 41, 1) forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确  定" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtn_click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:confirmBtn];
        _confirmBtn = confirmBtn;
        
    }
    
    return self;
}

- (void)changeTypeBtn_click:(id)sender{
    NSLog(@"123123");
}

- (void)confirmBtn_click:(id)sender{
    NSLog(@"confirm");
}

@end
