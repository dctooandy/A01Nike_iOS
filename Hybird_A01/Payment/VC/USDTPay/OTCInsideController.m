//
//  OTCInsideController.m
//  Hybird_A01
//
//  Created by Flynn on 2020/7/16.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "OTCInsideController.h"
#import "CNPayConstant.h"
#import "CNPayUSDTRateModel.h"
#import "OTCInsideCell.h"
#import "OTCInsideModel.h"

@interface OTCInsideController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIView *selectedLine;
@property (nonatomic, assign) BOOL isRecharge;
@property (nonatomic, strong) UIView *rechargeView;
@property (nonatomic, strong) UIView *buyView;
@property (nonatomic, strong) UIButton *ercBtn;
@property (nonatomic, strong) UIButton *omniBtn;
@property (nonatomic,copy) NSString *selectedProtocol;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UIImageView *qrcodeImg;
@property (nonatomic, strong) NSDictionary *qrJson;
@property (nonatomic, strong) UICollectionView *walletCollectionView;
@property (nonatomic, strong) NSArray *bankList;
@end

@implementation OTCInsideController

- (UICollectionView *)walletCollectionView
{
    if (!_walletCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 12;  //行间距
        flowLayout.minimumInteritemSpacing = 12; //列间距
//        flowLayout.estimatedItemSize = CGSizeMake((SCREEN_WIDTH-60)/3, 36);  //预定的itemsize
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-44)/2, (SCREEN_WIDTH-44)/3); //固定的itemsize
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        //初始化 UICollectionView
        _walletCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _walletCollectionView.delegate = self; //设置代理
        _walletCollectionView.dataSource = self;   //设置数据来源
        _walletCollectionView.backgroundColor = kBlackLightColor;
        _walletCollectionView.showsVerticalScrollIndicator = NO;
        
 
        _walletCollectionView.bounces = NO;   //设置弹跳
        _walletCollectionView.alwaysBounceVertical = NO;  //只允许垂直方向滑动
        //注册 cell  为了cell的重用机制  使用NIB  也可以使用代码 registerClass xxxx
        [_walletCollectionView registerClass:[OTCInsideCell class] forCellWithReuseIdentifier:@"OTCInsideCell"];
    }
    return _walletCollectionView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isRecharge = YES;
    _selectedProtocol = @"ERC20";
    self.title = @"充值/购买USDT";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292d36"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#292d36"];;
    [self setupViews];
    [self requestUSDTRate];
    [self requestQrcode];
    [self requestBankList];
}

- (void)requestBankList{
    [self showLoading];
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTQueryCounterList paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.bankList = result.body;
            [self.walletCollectionView reloadData];
            
        }
    }];
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
            
            weakSelf.rateLabel.attributedText = attrStr;
        }
    }];
}

- (void)requestQrcode{
    [self showLoading];
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTQueryCounterQRCode paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSDictionary *json = result.body;
            self.ercBtn.hidden = YES;
            self.omniBtn.hidden = YES;
            self.qrJson = json;
            if ([json objectForKey:@"erc20"]) {
                self.ercBtn.hidden = NO;
                self.selectedProtocol = @"ERC20";
                self.qrcodeImg.image = [PublicMethod QRCodeMethod:json[@"erc20"]];
            }
            if ([json objectForKey:@"omni"]) {
                self.omniBtn.hidden = NO;
                if (self.ercBtn.isHidden) {
                    self.omniBtn.frame = CGRectMake(16, 48, 100, 30);
                    [self omniBtn_click:nil];
                    self.qrcodeImg.image = [PublicMethod QRCodeMethod:json[@"omni"]];
                }
            }
            
            
        }
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bankList.count;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OTCInsideModel *model = [OTCInsideModel yy_modelWithJSON:self.bankList[indexPath.row]];
    if (model.otcMarketLink!=nil&&![model.otcMarketLink isEqualToString:@""]) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.title = model.otcMarketName;
        vc.webConfigModel.theme = @"outside";
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.url = model.otcMarketLink;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{

    OTCInsideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OTCInsideCell" forIndexPath:indexPath];
    [cell cellConfigJson:self.bankList[indexPath.row]];
    return cell;
}

- (void)setupViews{
    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH/2-16, 48)];
    [rechargeBtn setTitle:@"充值USDT" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(rechargeBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:rechargeBtn];
    self.rechargeBtn = rechargeBtn;
    
    UIView *buyLine = [[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 1)];
    buyLine.backgroundColor = kBlackLightColor;
    [self.contentView addSubview:buyLine];
    
    UIView *rechargeLine = [[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH/2, 1)];
    rechargeLine.backgroundColor = [UIColor colorWithHexString:@"#2d83cd"];
    [self.contentView addSubview:rechargeLine];
    self.selectedLine = rechargeLine;
    
    UIButton *buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-16, 48)];
    [buyBtn setTitle:@"购买USDT" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyBtn setTitleColor:[UIColor colorWithHexString:@"#6d737c"] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:buyBtn];
    self.buyBtn = buyBtn;
    [self setupRechargeView];
    [self setupBuyView];
    
}

- (void)setupBuyView{
    UIView *buyView = [[UIView alloc]init];
    buyView.hidden = YES;
    buyView.backgroundColor = [UIColor colorWithHexString:@"#292d36"];;
    [self.contentView addSubview:buyView];
    self.buyView = buyView;
    [self.buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(49);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
    
    
    [self.buyView addSubview:self.walletCollectionView];
    [self.walletCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.buyView).offset(16);
        make.bottom.right.mas_equalTo(self.buyView).offset(-16);
    }];
    
}

- (void)setupRechargeView{
    UIView *rechargeView = [[UIView alloc]init];
    rechargeView.backgroundColor = [UIColor colorWithHexString:@"#292d36"];;
    [self.contentView addSubview:rechargeView];
    self.rechargeView = rechargeView;
    [self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(49);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
    
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = @"选择支付协议";
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textColor = [UIColor whiteColor];
    [self.rechargeView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.rechargeView).offset(16);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.rechargeView);
    }];
    
    UIButton *ercBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 48, 100, 30)];
    [ercBtn setTitle:@"ERC20" forState:UIControlStateNormal];
    ercBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ercBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ercBtn.layer.cornerRadius = 4.0;
    ercBtn.clipsToBounds = YES;
    ercBtn.layer.borderWidth = 0.5;
    ercBtn.layer.borderColor = [UIColor colorWithHexString:@"#2d83cd"].CGColor;
    [ercBtn addTarget:self action:@selector(ercBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView addSubview:ercBtn];
    self.ercBtn = ercBtn;
    
    UIButton *omniBtn = [[UIButton alloc]initWithFrame:CGRectMake(132, 48, 100, 30)];
    [omniBtn setTitle:@"OMNI" forState:UIControlStateNormal];
    omniBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [omniBtn setTitleColor:[UIColor colorWithHexString:@"#6d737c"] forState:UIControlStateNormal];
    omniBtn.layer.cornerRadius = 4.0;
    omniBtn.clipsToBounds = YES;
    omniBtn.layer.borderWidth = 0.5;
    omniBtn.layer.borderColor = [UIColor colorWithHexString:@"#6d737c"].CGColor;
    [omniBtn addTarget:self action:@selector(omniBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView addSubview:omniBtn];
    self.omniBtn = omniBtn;
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"请慎重选择协议类型,若协议类型错误则款项无法到账";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    [self.rechargeView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rechargeView).offset(16);
        make.top.mas_equalTo(self.ercBtn.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.rechargeView).offset(-16);
    }];
    
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#22222a"];
    [self.rechargeView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.rechargeView);
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *rechargeTipLabel = [[UILabel alloc]init];
    rechargeTipLabel.text = @"最低充值 20 USDT,无需填写充值金额,\n充值成功后款项将自动添加到帐";
    rechargeTipLabel.numberOfLines = 2;
    rechargeTipLabel.textAlignment = NSTextAlignmentCenter;
    rechargeTipLabel.font = [UIFont systemFontOfSize:12];
    rechargeTipLabel.textColor = [UIColor whiteColor];
    [self.rechargeView addSubview:rechargeTipLabel];
    [rechargeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rechargeView).offset(16);
        make.top.mas_equalTo(sepView.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.rechargeView).offset(-16);
    }];
    
    UIButton *commitBtn = [[UIButton alloc]init];
    [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitBtn setTitle:@"充值完成" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    commitBtn.layer.cornerRadius = 4;
    [commitBtn addTarget:self action:@selector(commitBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.backgroundColor = COLOR_RGBA(241, 216, 52, 1);
    [self.rechargeView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.rechargeView.mas_bottom).offset(-60);
        make.left.mas_equalTo(self.rechargeView).offset(16);
        make.right.mas_equalTo(self.rechargeView).offset(-16);
        make.height.mas_equalTo(45);
    }];
    
    UILabel *rateLabel = [[UILabel alloc]init];
    rateLabel.text = @"当前参考汇率 1USDT=7.20元,请以实际汇率为准.";
    rateLabel.numberOfLines = 2;
    rateLabel.textAlignment = NSTextAlignmentCenter;
    rateLabel.font = [UIFont systemFontOfSize:12];
    rateLabel.textColor = [UIColor colorWithHexString:@"#818791"];
    [self.rechargeView addSubview:rateLabel];
    self.rateLabel = rateLabel;
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rechargeView).offset(16);
        make.bottom.mas_equalTo(commitBtn.mas_top).offset(-20);
        make.height.mas_greaterThanOrEqualTo(20);
        make.right.mas_equalTo(self.rechargeView).offset(-16);
    }];
    
    UIImageView *qrCodeView = [[UIImageView alloc]init];
    qrCodeView.image = [PublicMethod QRCodeMethod:@""];
    qrCodeView.contentMode = UIViewContentModeScaleAspectFit;
    [self.rechargeView addSubview:qrCodeView];
    self.qrcodeImg = qrCodeView;
    [qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rechargeTipLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(rateLabel.mas_top).offset(-20);
        make.left.right.mas_equalTo(self.rechargeView);
    }];
}

- (void)ercBtn_click:(id)sender{
    if ([_selectedProtocol isEqualToString:@"OMNI"]) {
        [self.ercBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.omniBtn setTitleColor:[UIColor colorWithHexString:@"#6d737c"] forState:UIControlStateNormal];
        self.ercBtn.layer.borderColor = [UIColor colorWithHexString:@"#2d83cd"].CGColor;
        self.omniBtn.layer.borderColor = [UIColor colorWithHexString:@"#6d737c"].CGColor;
        self.selectedProtocol = @"ERC20";
        self.qrcodeImg.image = [PublicMethod QRCodeMethod:self.qrJson[@"erc20"]];
    }
}
- (void)omniBtn_click:(id)sender{
    if ([_selectedProtocol isEqualToString:@"ERC20"]) {
        [self.omniBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.ercBtn setTitleColor:[UIColor colorWithHexString:@"#6d737c"] forState:UIControlStateNormal];
        self.omniBtn.layer.borderColor = [UIColor colorWithHexString:@"#2d83cd"].CGColor;
        self.ercBtn.layer.borderColor = [UIColor colorWithHexString:@"#6d737c"].CGColor;
        self.selectedProtocol = @"OMNI";
        self.qrcodeImg.image = [PublicMethod QRCodeMethod:self.qrJson[@"omni"]];
    }
}

- (void)rechargeBtn_click:(id)sender{
    if (!_isRecharge) {
        [self.buyBtn setTitleColor:[UIColor colorWithHexString:@"#6d737c"] forState:UIControlStateNormal];
        [self.rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedLine.origin = CGPointMake(0, 48);
        }];
        _isRecharge = YES;
        self.rechargeView.hidden = NO;
        self.buyView.hidden = YES;
    }
    
}

- (void)buyBtn_click:(id)sender{
    if (_isRecharge) {
        [self.rechargeBtn setTitleColor:[UIColor colorWithHexString:@"#6d737c"] forState:UIControlStateNormal];
        [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedLine.origin = CGPointMake(SCREEN_WIDTH/2, 48);
        }];
        _isRecharge = NO;
        self.rechargeView.hidden = YES;
        self.buyView.hidden = NO;
    }
}

- (void)commitBtn_click:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
