//
//  BTTWithDrawProtocolView.m
//  Hybird_1e3c3b
//
//  Created by Levy on 3/10/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithDrawProtocolView.h"
#import "CNPayConstant.h"
#define protocolBtnW 90
#define protocolBtnH 30
#define diff 10

@interface BTTWithDrawProtocolView ()

@property (nonatomic, strong) UIButton *omniBtn;
@property (nonatomic, strong) UIButton *ercBtn;
@property (nonatomic, strong) UIButton *trcBtn;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UILabel *protocolSubLabel;

@end
@implementation BTTWithDrawProtocolView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    if (self) {
        self.contentView.backgroundColor = kBlackLightColor;
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        infoView.backgroundColor = kBlackLightColor;
        [self.contentView addSubview:infoView];
        
        _protocolLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, 100, 20)];
        _protocolLabel.text = @"协议";
        _protocolLabel.textColor = [UIColor whiteColor];
        _protocolLabel.font = [UIFont boldSystemFontOfSize:16];
        [infoView addSubview:_protocolLabel];
        
        _trcBtn = [self getPortocalBtn];
//        _trcBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 95 - diff, 5, protocolBtnW, protocolBtnH)];
        _trcBtn.frame = CGRectMake(SCREEN_WIDTH- 95 - diff, 5, protocolBtnW, protocolBtnH);
        [_trcBtn setTitle:@"TRC20" forState:UIControlStateNormal];
        [_trcBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _trcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        _trcBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
//        _trcBtn.layer.cornerRadius = 4.0;
//        _trcBtn.layer.borderWidth = 0.5;
//        _trcBtn.clipsToBounds = YES;
        [_trcBtn addTarget:self action:@selector(trcBtn_click) forControlEvents:UIControlEventTouchUpInside];
        UILabel *youCanTrustLabel = [[UILabel alloc] initWithFrame:CGRectMake(protocolBtnW - 20, 0, 20, 15)];
        youCanTrustLabel.backgroundColor = [UIColor redColor];
        youCanTrustLabel.font = [UIFont systemFontOfSize:8];;
        youCanTrustLabel.textColor = [UIColor whiteColor];
        youCanTrustLabel.textAlignment = NSTextAlignmentCenter;
        youCanTrustLabel.text = @"推荐";
        youCanTrustLabel.layer.cornerRadius = 5;
        youCanTrustLabel.layer.masksToBounds = true;
        UIImageView *trustImgView = [[UIImageView alloc] initWithImage:ImageNamed(@"A01_H5APP_充值&取款")];
        trustImgView.frame = CGRectMake(protocolBtnW/2 - 8, -10, 34, 19);
//        [youCanTrustLabel setHidden:YES];
        [_trcBtn addSubview:trustImgView];
        [infoView addSubview:_trcBtn];
        
        _ercBtn = [self getPortocalBtn];
        _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
//        _ercBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH)];
        [_ercBtn setTitle:@"ERC20" forState:UIControlStateNormal];
        [_ercBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ercBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
//        _ercBtn.layer.cornerRadius = 4.0;
//        _ercBtn.layer.borderWidth = 0.5;
//        _ercBtn.clipsToBounds = YES;
        [_ercBtn addTarget:self action:@selector(ercBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:_ercBtn];
        
        _omniBtn = [self getPortocalBtn];
        _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
//        _omniBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH)];
        [_omniBtn setTitle:@"OMNI" forState:UIControlStateNormal];
        [_omniBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _omniBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        _omniBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
//        _omniBtn.layer.cornerRadius = 4.0;
//        _omniBtn.layer.borderWidth = 0.5;
//        _omniBtn.clipsToBounds = YES;
        [_omniBtn addTarget:self action:@selector(omniBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:_omniBtn];
        _protocolSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 38, SCREEN_WIDTH - 40, 20)];
        _protocolSubLabel.text = @"建议优先使用TRC20协议,手续费更低";
        _protocolSubLabel.textColor = [UIColor redColor];
        _protocolSubLabel.font = [UIFont boldSystemFontOfSize:11];
        [_protocolSubLabel setHidden:YES];
        [infoView addSubview:_protocolSubLabel];
    }
    return self;
}
#pragma mark - Protocol

- (UIButton *)getPortocalBtn {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_newrecharge_sel"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    return btn;
}
- (void)setTypeData:(NSArray *)types{
    [_protocolSubLabel setHidden:YES];
    _protocolLabel.text = @"协议";
    if ([types containsObject:@"OMNI"]) {
        _omniBtn.hidden = NO;
        _ercBtn.hidden = ![types containsObject:@"ERC20"];
        _trcBtn.hidden = ![types containsObject:@"TRC20"];
        [self omniBtn_click];
        if (!_ercBtn.isHidden && !_trcBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
        } else if (!_ercBtn.isHidden && _trcBtn.isHidden) {
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
        } else if (_ercBtn.isHidden && !_trcBtn.isHidden) {
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
        } else {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
        }
    } else if ([types containsObject:@"ERC20"]) {
        BOOL isTrcLast = [types.lastObject isEqualToString:@"TRC20"];
        _ercBtn.hidden = NO;
        _omniBtn.hidden = ![types containsObject:@"OMNI"];
        _trcBtn.hidden = ![types containsObject:@"TRC20"];
        _protocolLabel.text = @"选择协议";
        if (!_omniBtn.isHidden && !_trcBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
            [self ercBtn_click];
        } else if (!_omniBtn.isHidden && _trcBtn.isHidden) {
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
            [self ercBtn_click];
        } else if (_omniBtn.isHidden && !_trcBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
            [self ercBtn_click];
        } else {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
            [self ercBtn_click];
        }
    } else {
        _trcBtn.hidden = NO;
        _omniBtn.hidden = ![types containsObject:@"OMNI"];
        _ercBtn.hidden = ![types containsObject:@"ERC20"];
        
        if (!_omniBtn.isHidden && !_ercBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            [self omniBtn_click];
        } else if (!_omniBtn.isHidden && _ercBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            [self omniBtn_click];
        } else if (_omniBtn.isHidden && !_ercBtn.isHidden) {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            [self ercBtn_click];
        } else {
            _omniBtn.frame = CGRectMake(SCREEN_WIDTH-285 - diff, 5, protocolBtnW, protocolBtnH);
            _ercBtn.frame = CGRectMake(SCREEN_WIDTH-190 - diff, 5, protocolBtnW, protocolBtnH);
            _trcBtn.frame = CGRectMake(SCREEN_WIDTH-95 - diff, 5, protocolBtnW, protocolBtnH);
            [self trcBtn_click];
        }
    }
}

-(void)trcBtn_click {
//    _trcBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
//    _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
//    _omniBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    [_omniBtn setSelected:NO];
    [_ercBtn setSelected:NO];
    [_trcBtn setSelected:YES];
    [_protocolSubLabel setHidden:YES];
    if (self.tapProtocol) {
        self.tapProtocol(@"TRC20");
    }
}

- (void)omniBtn_click{
//    _omniBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
//    _ercBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
//    _trcBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    [_omniBtn setSelected:YES];
    [_ercBtn setSelected:NO];
    [_trcBtn setSelected:NO];
    [_protocolSubLabel setHidden:YES];
    if (self.tapProtocol) {
        self.tapProtocol(@"OMNI");
    }
}

- (void)ercBtn_click{
//    _ercBtn.layer.borderColor = COLOR_RGBA(36, 151, 255, 1).CGColor;
//    _omniBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
//    _trcBtn.layer.borderColor = COLOR_RGBA(74, 74, 110, 1).CGColor;
    [_omniBtn setSelected:NO];
    [_ercBtn setSelected:YES];
    [_trcBtn setSelected:NO];
    [_protocolSubLabel setHidden:NO];
    if (self.tapProtocol) {
        self.tapProtocol(@"ERC20");
    }
}

@end
