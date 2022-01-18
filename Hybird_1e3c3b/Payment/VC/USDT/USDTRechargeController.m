//
//  USDTRechargeController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 12/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "USDTRechargeController.h"
#import "CNPayUSDTRateModel.h"
#import "OCTRechargeUSDTView.h"
#define ERCType 0
#define TRCType 1

@interface USDTRechargeController ()
@property (nonatomic, strong) OCTRechargeUSDTView * rechargeView;
@property (nonatomic,copy) NSString *selectedProtocol;
@property (nonatomic, strong) NSDictionary *qrJson;
@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation USDTRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedProtocol = @"ERC20";
    self.title = @"充值USDT";
    self.navigationController.navigationBarHidden = NO;
    [self setupViews];
    [self requestUSDTRate];
    [self requestQrcode:ERCType];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isFirstLoad) {
        [CNTimeLog endRecordTime:CNEventPayLaunch];
        _isFirstLoad = YES;
    }
}

-(void)setupViews {
    [self.view addSubview:self.rechargeView];
    [self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KIsiPhoneX ? 88 : 64);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.rechargeView.ercBtn addTarget:self action:@selector(ercBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView.trcBtn addTarget:self action:@selector(trcBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView.omniBtn addTarget:self action:@selector(omniBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView.commitBtn addTarget:self action:@selector(commitBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView.urlCopyBtn addTarget:self action:@selector(urlCopyBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)requestUSDTRate{
    [self showLoading];
    weakSelf(weakSelf)
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"amount"] = @1;
    params[@"srcCurrency"] = @"USDT";
    params[@"tgtCurrency"] = @"CNY";
    params[@"used"] = @"1";
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    [IVNetwork requestPostWithUrl:BTTCurrencyExchanged paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            
            CNPayUSDTRateModel *rateModel = [CNPayUSDTRateModel yy_modelWithJSON:result.body];
            if (error && !rateModel) {
                return;
            }
            
            NSArray *rateArray = [rateModel.rate componentsSeparatedByString:@"."];
            
            NSString *rateDetail =rateArray.lastObject;
            if (rateDetail.length>2) {
                rateDetail = [rateDetail substringToIndex:2];
            }
            NSString *rate = [NSString stringWithFormat:@"%@.%@",rateArray.firstObject,rateDetail];
            
            NSString *str = [NSString stringWithFormat:@"当前参考汇率：1 USDT=%@ CNY，实际请以到账时为准",rate];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
            
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:[UIColor whiteColor]
                            range:NSMakeRange(7, 11+rate.length)];
            
            weakSelf.rechargeView.rateLabel.attributedText = attrStr;
        }
    }];
}

- (void)requestQrcode:(NSInteger)type{
    [self showLoading];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"0" forKey:@"tranAmount"];
    [params setValue:@"25" forKey:@"payType"];
    [params setValue:@"USDT" forKey:@"currency"];
    [params setValue:type == 0 ? @"ERC20":@"TRC20" forKey:@"protocol"];
    
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTRechargeUSDTQrcode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSDictionary *dict = result.body;
            if (type == 0) {
                self.selectedProtocol = @"ERC20";
            } else if (type == 1) {
                self.selectedProtocol = @"TRC20";
            }
            weakSelf.rechargeView.qrcodeImg.image = [PublicMethod QRCodeMethod:dict[@"address"]];
            weakSelf.rechargeView.locationUrlTextView.text = dict[@"address"];
        }
    }];
}

- (void)ercBtn_click:(id)sender{
    if ([_selectedProtocol isEqualToString:@"TRC20"]) {
        [self requestQrcode:ERCType];
        [self.rechargeView.ercBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rechargeView.trcBtn setTitleColor:[UIColor colorWithHexString:@"#6d737c"] forState:UIControlStateNormal];
        self.rechargeView.ercBtn.layer.borderColor = [UIColor colorWithHexString:@"#2d83cd"].CGColor;
        self.rechargeView.trcBtn.layer.borderColor = [UIColor colorWithHexString:@"#6d737c"].CGColor;
        self.selectedProtocol = @"ERC20";
    }
}
- (void)trcBtn_click:(id)sender{
    if ([_selectedProtocol isEqualToString:@"ERC20"]) {
        [self requestQrcode:TRCType];
        [self.rechargeView.trcBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rechargeView.ercBtn setTitleColor:[UIColor colorWithHexString:@"#6d737c"] forState:UIControlStateNormal];
        self.rechargeView.trcBtn.layer.borderColor = [UIColor colorWithHexString:@"#2d83cd"].CGColor;
        self.rechargeView.ercBtn.layer.borderColor = [UIColor colorWithHexString:@"#6d737c"].CGColor;
        self.selectedProtocol = @"TRC20";
    }
}

- (void)commitBtn_click:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)urlCopyBtnAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.rechargeView.locationUrlTextView.text;
    [MBProgressHUD showSuccess:@"已复制" toView:nil];
}

-(OCTRechargeUSDTView *)rechargeView {
    if (!_rechargeView) {
        _rechargeView = [[OCTRechargeUSDTView alloc] init];
    }
    return _rechargeView;
}

@end
