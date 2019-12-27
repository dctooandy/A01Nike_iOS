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

@end

@implementation BTTWithDrawUSDTConfirmCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    if (self) {
        UILabel *rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 300, 12)];
        rateLabel.font = [UIFont systemFontOfSize:12.0];
        rateLabel.textColor = COLOR_RGBA(129, 135, 145, 1);
        rateLabel.text = @"（当前参考汇率：1CNY= 0.142USDT）";
        [self.contentView addSubview:rateLabel];
        _ratelabel = rateLabel;
        
    }
    
    return self;
}

-(void)setCellRateWithRate:(CGFloat)rate{
    _ratelabel.text = [NSString stringWithFormat:@"（当前参考汇率：1CNY= %.4fUSDT）",rate];
}


- (void)confirmBtn_click:(id)sender{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
