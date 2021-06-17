//
//  BTTWithDrawUSDTConfirmCell.m
//  Hybird_1e3c3b
//
//  Created by Levy on 12/25/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTWithDrawUSDTConfirmCell.h"

@interface BTTWithDrawUSDTConfirmCell()
@property (nonatomic, strong) UILabel *ratelabel;
@property (nonatomic, strong) UILabel *noticeLab;
@end

@implementation BTTWithDrawUSDTConfirmCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    if (self) {
        UILabel *noticeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15*2, 13)];
        noticeLab.font = [UIFont systemFontOfSize:13.0];
        noticeLab.textAlignment = NSTextAlignmentRight;
        noticeLab.textColor = [UIColor colorWithRed: 0.15 green: 0.66 blue: 1.00 alpha: 1.00];
        noticeLab.text = @"请确认取款钱包是否正常使用!";
        [self.contentView addSubview:noticeLab];
        _noticeLab = noticeLab;
        
        UILabel *rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 33, SCREEN_WIDTH-15*2, 13)];
        rateLabel.font = [UIFont systemFontOfSize:13.0];
        rateLabel.textColor = COLOR_RGBA(129, 135, 145, 1);
        rateLabel.text = @"（当前参考汇率：1CNY= 0.142USDT）";
        [self.contentView addSubview:rateLabel];
        _ratelabel = rateLabel;
        
    }
    
    return self;
}

-(void)setCellRateWithRate:(CGFloat)rate{
    _ratelabel.textAlignment = NSTextAlignmentLeft;
    _ratelabel.textColor = COLOR_RGBA(129, 135, 145, 1);
    _ratelabel.text = [NSString stringWithFormat:@"（当前参考汇率：1CNY= %.4fUSDT）",rate];
}


- (void)confirmBtn_click:(id)sender{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
