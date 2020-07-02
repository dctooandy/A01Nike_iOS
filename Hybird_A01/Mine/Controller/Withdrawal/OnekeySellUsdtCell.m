//
//  OnekeySellUsdtCell.m
//  Hybird_A01
//
//  Created by Flynn on 2020/7/1.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "OnekeySellUsdtCell.h"
#import "CNPayConstant.h"

@interface OnekeySellUsdtCell ()
@property (nonatomic, strong) UIButton *onekeySellBtn;
@end

@implementation OnekeySellUsdtCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (self) {
        self.contentView.backgroundColor = kBlackBackgroundColor;
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        infoView.backgroundColor = kBlackBackgroundColor;
        [self.contentView addSubview:infoView];
        
        UIButton *oneKeySellBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 112, SCREEN_WIDTH-32, 44)];
        [oneKeySellBtn setTitle:@"一键卖币" forState:UIControlStateNormal];
        
        oneKeySellBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [oneKeySellBtn setTitleColor:COLOR_HEX(0x2497FF) forState:UIControlStateNormal];
        [oneKeySellBtn addTarget:self action:@selector(oneKeySellUsdt) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:oneKeySellBtn];
        _onekeySellBtn = oneKeySellBtn;
        

        
        
    }
    return self;
}

- (void)sellHidden:(BOOL)sellHidden{
    self.onekeySellBtn.hidden = !sellHidden;
}

- (void)oneKeySellUsdt{
    if (self.oneKeySell) {
        self.oneKeySell();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
