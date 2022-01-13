//
//  BTTAddUsdtHeaderCell.m
//  Hybird_1e3c3b
//
//  Created by Levy on 1/31/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTAddUsdtHeaderCell.h"
#import "CNPayConstant.h"

@interface BTTAddUsdtHeaderCell ()

@property (nonatomic, strong) UIButton *omniBtn;
@property (nonatomic, strong) UIButton *ercBtn;
@property (nonatomic, strong) UIButton *trcBtn;

@end

@implementation BTTAddUsdtHeaderCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    if (self) {
        self.contentView.backgroundColor = kBlackLightColor;
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
        infoView.backgroundColor = kBlackLightColor;
        [self.contentView addSubview:infoView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, 100, 20)];
        label.text = @"协议";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        [infoView addSubview:label];
        
        _trcBtn = [[UIButton alloc]initWithFrame:CGRectMake(246, 44, 100, 31)];
        [_trcBtn setTitle:@"ERC20" forState:UIControlStateNormal];
        [_trcBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _trcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _trcBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
        _trcBtn.layer.cornerRadius = 4.0;
        _trcBtn.layer.borderWidth = 0.5;
        _trcBtn.clipsToBounds = YES;
        [_trcBtn addTarget:self action:@selector(trcBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:_trcBtn];
        
        _ercBtn = [[UIButton alloc]initWithFrame:CGRectMake(131, 44, 100, 31)];
        [_ercBtn setTitle:@"ERC20" forState:UIControlStateNormal];
        [_ercBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ercBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
        _ercBtn.layer.cornerRadius = 4.0;
        _ercBtn.layer.borderWidth = 0.5;
        _ercBtn.clipsToBounds = YES;
        [_ercBtn addTarget:self action:@selector(ercBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:_ercBtn];
        
        self.omniBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 44, 100, 31)];
        [_omniBtn setTitle:@"OMNI" forState:UIControlStateNormal];
        [_omniBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _omniBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _omniBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
        _omniBtn.layer.cornerRadius = 4.0;
        _omniBtn.layer.borderWidth = 0.5;
        _omniBtn.clipsToBounds = YES;
        [_omniBtn addTarget:self action:@selector(omniBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:_omniBtn];
        
    }
    return self;
}

- (void)setTypeData:(NSString *)types{
    NSArray * arr = [types componentsSeparatedByString:@";"];
    
    if ([arr containsObject:@"OMNI"]) {
        _omniBtn.hidden = NO;
        _ercBtn.hidden = ![arr containsObject:@"ERC20"];
        _trcBtn.hidden = ![arr containsObject:@"TRC20"];
        
        _omniBtn.frame = CGRectMake(16, 44, 100, 31);
        _ercBtn.frame = CGRectMake(131, 44, 100, 31);
        _trcBtn.frame = CGRectMake(246, 44, 100, 31);
        [self omniBtn_click];
        
    } else if ([arr containsObject:@"ERC20"]) {
        _omniBtn.hidden = YES;
        _omniBtn.frame = CGRectMake(16, 44, 100, 31);
        _ercBtn.hidden = NO;
        _ercBtn.frame = CGRectMake(16, 44, 100, 31);
        [self ercBtn_click];
        if ([arr containsObject:@"TRC20"]) {
            _trcBtn.hidden = NO;
            _trcBtn.frame = CGRectMake(131, 44, 100, 31);
        }else{
            _trcBtn.hidden = YES;
            _trcBtn.frame = CGRectMake(131, 44, 100, 31);
        }
        
    } else if ([arr containsObject:@"TRC20"]) {
        _omniBtn.frame = CGRectMake(16, 44, 100, 31);
        _omniBtn.hidden = YES;
        _ercBtn.frame = CGRectMake(16, 44, 100, 31);
        _ercBtn.hidden = YES;
        _trcBtn.frame = CGRectMake(16, 44, 100, 31);
        _trcBtn.hidden = NO;
        [self trcBtn_click];
    }
}

-(void)trcBtn_click {
    _trcBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
    _omniBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    if (self.tapProtocol) {
        self.tapProtocol(@"OMNI");
    }
}

- (void)omniBtn_click{
    _omniBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
    _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    _trcBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    if (self.tapProtocol) {
        self.tapProtocol(@"OMNI");
    }
}

- (void)ercBtn_click{
    _ercBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
    _omniBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    _trcBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    if (self.tapProtocol) {
        self.tapProtocol(@"ERC20");
    }
}

@end
