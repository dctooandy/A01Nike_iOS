//
//  BTTWithDrawProtocolView.m
//  Hybird_1e3c3b
//
//  Created by Levy on 3/10/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithDrawProtocolView.h"
#import "CNPayConstant.h"
#define protocolBtnW 80
#define protocolBtnH 30

@interface BTTWithDrawProtocolView ()

@property (nonatomic, strong) UIButton *omniBtn;
@property (nonatomic, strong) UIButton *ercBtn;
@property (nonatomic, strong) UIButton *trcBtn;

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
        
        _trcBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH)];
        [_trcBtn setTitle:@"TRC20" forState:UIControlStateNormal];
        [_trcBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _trcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _trcBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
        _trcBtn.layer.cornerRadius = 4.0;
        _trcBtn.layer.borderWidth = 0.5;
        _trcBtn.clipsToBounds = YES;
        [_trcBtn addTarget:self action:@selector(trcBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:_trcBtn];
        
        _ercBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH)];
        [_ercBtn setTitle:@"ERC20" forState:UIControlStateNormal];
        [_ercBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ercBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
        _ercBtn.layer.cornerRadius = 4.0;
        _ercBtn.layer.borderWidth = 0.5;
        _ercBtn.clipsToBounds = YES;
        [_ercBtn addTarget:self action:@selector(ercBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:_ercBtn];
        
        _omniBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH)];
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
    if ([types containsObject:@"OMNI"]) {
        _omniBtn.hidden = NO;
        _ercBtn.hidden = ![types containsObject:@"ERC20"];
        _trcBtn.hidden = ![types containsObject:@"TRC20"];
        [self omniBtn_click];
        if (!_ercBtn.isHidden && !_trcBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
        } else if (!_ercBtn.isHidden && _trcBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
        } else if (_ercBtn.isHidden && !_trcBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
        } else {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
        }
    } else if ([types containsObject:@"ERC20"]) {
        _ercBtn.hidden = NO;
        _omniBtn.hidden = ![types containsObject:@"OMNI"];
        _trcBtn.hidden = ![types containsObject:@"TRC20"];
        if (!_omniBtn.isHidden && !_trcBtn.isHidden) {
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            [self omniBtn_click];
        } else if (!_omniBtn.isHidden && _trcBtn.isHidden) {
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
            [self omniBtn_click];
        } else if (_omniBtn.isHidden && !_trcBtn.isHidden) {
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
            [self ercBtn_click];
        } else {
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
            [self ercBtn_click];
        }
    } else {
        _trcBtn.hidden = NO;
        _omniBtn.hidden = ![types containsObject:@"OMNI"];
        _ercBtn.hidden = ![types containsObject:@"ERC20"];
        
        if (!_omniBtn.isHidden && !_ercBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            [self omniBtn_click];
        } else if (!_omniBtn.isHidden && _ercBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            [self omniBtn_click];
        } else if (_omniBtn.isHidden && !_ercBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            [self ercBtn_click];
        } else {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95, 5, protocolBtnW, protocolBtnH);
            [self trcBtn_click];
        }
    }
}

-(void)trcBtn_click {
    _trcBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
    _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    _omniBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    if (self.tapProtocol) {
        self.tapProtocol(@"TRC20");
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
