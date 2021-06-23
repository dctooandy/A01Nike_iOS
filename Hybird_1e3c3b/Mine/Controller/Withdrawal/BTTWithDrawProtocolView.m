//
//  BTTWithDrawProtocolView.m
//  Hybird_1e3c3b
//
//  Created by Levy on 3/10/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithDrawProtocolView.h"
#import "CNPayConstant.h"

@interface BTTWithDrawProtocolView ()

@property (nonatomic, strong) UIButton *omniBtn;
@property (nonatomic, strong) UIButton *ercBtn;

@end
@implementation BTTWithDrawProtocolView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (self) {
        self.contentView.backgroundColor = kBlackLightColor;
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        infoView.backgroundColor = kBlackLightColor;
        [self.contentView addSubview:infoView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, 100, 20)];
        label.text = @"协议";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        [infoView addSubview:label];
        
        _ercBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-115, 5, 100, 30)];
        [_ercBtn setTitle:@"ERC20" forState:UIControlStateNormal];
        [_ercBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ercBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
        _ercBtn.layer.cornerRadius = 4.0;
        _ercBtn.layer.borderWidth = 0.5;
        _ercBtn.clipsToBounds = YES;
        [_ercBtn addTarget:self action:@selector(ercBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:_ercBtn];
        
        self.omniBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-230, 5, 100, 30)];
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

- (void)setTypeData:(NSArray *)types{
    if ([types containsObject:@"ERC20"]) {
        _omniBtn.hidden = ![types containsObject:@"OMNI"];
        _ercBtn.hidden = NO;
        _ercBtn.frame = CGRectMake(SCREEN_WIDTH-115, 5, 100, 30);
        _omniBtn.frame = CGRectMake(SCREEN_WIDTH-230, 5, 100, 30);
        if (!_omniBtn.isHidden) {
            [self omniBtn_click];
        }else{
            [self ercBtn_click];
        }
        
    }else{
        _ercBtn.frame = CGRectMake(SCREEN_WIDTH-115, 5, 100, 30);
        _omniBtn.frame = CGRectMake(SCREEN_WIDTH-115, 5, 100, 30);
        _ercBtn.hidden = YES;
        if ([types containsObject:@"OMNI"]) {
            _omniBtn.hidden = NO;
            [self omniBtn_click];
        }
    }
}

- (void)omniBtn_click{
    _omniBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
    _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    if (self.tapProtocol) {
        self.tapProtocol(@"OMNI");
    }
}

- (void)ercBtn_click{
    _ercBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
    _omniBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    if (self.tapProtocol) {
        self.tapProtocol(@"ERC20");
    }
}

@end
