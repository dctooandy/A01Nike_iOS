//
//  BTTDcboxPayController.m
//  Hybird_A01
//
//  Created by Levy on 7/15/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTDcboxPayController.h"
#import "CNPayConstant.h"
#import "BTTBitollChoseMoneyCell.h"
#import "CNPayUSDTRateModel.h"
#import "BTTPayUsdtNoticeView.h"
#import "BTTUsdtWalletModel.h"
#import "BTTCardInfosController.h"
#import "USDTWalletCollectionCell.h"
#import "USDTBuyController.h"

@interface BTTDcboxPayController ()<UITextFieldDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *choseMoneyView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *usdtLabel;
@property (weak, nonatomic) IBOutlet UILabel *usdtTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) UICollectionView *walletCollectionView;
@property (weak, nonatomic) IBOutlet UIView *saveView;
@property (nonatomic, copy) NSString *selectedProtocol;
@property (nonatomic, assign) CGFloat usdtRate;
@property (nonatomic, strong) NSArray *moneyArray;
@property (nonatomic, copy) NSString *selectedMoney;
@property  BTTUsdtWalletModel *bfbModel;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *secondMoneyView;
@property (weak, nonatomic) IBOutlet UILabel *secondMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondArriveLabel;
@property (weak, nonatomic) IBOutlet UIView *secondArriveView;
@property (weak, nonatomic) IBOutlet UIImageView *bfbNoteImg;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeView;
@property (weak, nonatomic) IBOutlet UIButton *saveFinishBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bfbBanner;
@property (weak, nonatomic) IBOutlet UIView *arriveView;
@property (weak, nonatomic) IBOutlet UIImageView *dcboxDownload;
@property (nonatomic, strong) NSArray *protocolArray;
@property (weak, nonatomic) IBOutlet UIButton *onekeyBuyBtn;
@property (weak, nonatomic) IBOutlet UIButton *onekeyBtnTwo;
@property (nonatomic, copy) NSString *buyUsdtLink;
@end

@implementation BTTDcboxPayController

- (UICollectionView *)walletCollectionView
{
    if (!_walletCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 12;  //行间距
        flowLayout.minimumInteritemSpacing = 12; //列间距
//        flowLayout.estimatedItemSize = CGSizeMake((SCREEN_WIDTH-60)/3, 36);  //预定的itemsize
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-90)/4, 36); //固定的itemsize
        flowLayout.headerReferenceSize = CGSizeMake(0, 43);
        //初始化 UICollectionView
        _walletCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _walletCollectionView.delegate = self; //设置代理
        _walletCollectionView.dataSource = self;   //设置数据来源
        _walletCollectionView.backgroundColor = kBlackLightColor;
        
        [_walletCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
 
        _walletCollectionView.bounces = NO;   //设置弹跳
        _walletCollectionView.alwaysBounceVertical = NO;  //只允许垂直方向滑动
        //注册 cell  为了cell的重用机制  使用NIB  也可以使用代码 registerClass xxxx
        [_walletCollectionView registerClass:[BTTBitollChoseMoneyCell class] forCellWithReuseIdentifier:@"BTTBitollChoseMoneyCell"];
        [_walletCollectionView registerClass:[USDTWalletCollectionCell class] forCellWithReuseIdentifier:@"USDTWalletCollectionCell"];
    }
    return _walletCollectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:600 fullScreen:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedProtocol = @"OMNI";
    self.selectedMoney = @"100";
    self.moneyArray = @[@"100",@"500",@"1000",@"5000",@"10000",@"50000",@"100000"];
    [self setupView];
    [self.walletCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self requestUSDTRate];
    [self requestWalletType];
    [self requestBuyUsdtLink];
    [self setViewHeight:600 fullScreen:NO];
}


- (void)requestWalletType{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"5" forKey:@"bqpaytype"];
    [params setValue:@"1" forKey:@"flag"];
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTUsdtWallets paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if ([result.body isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *paymentArray = [[NSMutableArray alloc]init];
                NSArray *array = result.body;
                for (int i=0; i<array.count; i++) {
                    NSDictionary *json = array[i];
                    BTTUsdtWalletModel *model = [BTTUsdtWalletModel yy_modelWithDictionary:json];
                    weakSelf.bfbModel = model;
                    if ([model.flag isEqualToString:@"1"]&&[model.bankcode isEqualToString:@"dcbox"]) {
                        [paymentArray addObject:json];
                        if (model.maxAmount==nil||model.minAmount==nil) {
                            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入存款金额" attributes:
                            @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                                         NSFontAttributeName:weakSelf.moneyTextField.font
                                 }];
                            weakSelf.moneyTextField.attributedPlaceholder = attrString;
                        }else{
                            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"最低%@，最高%@",model.minAmount,model.maxAmount] attributes:
                            @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                                         NSFontAttributeName:weakSelf.moneyTextField.font
                                 }];
                            weakSelf.moneyTextField.attributedPlaceholder = attrString;
                        }
                        
                        [self.walletCollectionView reloadData];
                        
                        BTTUsdtWalletModel *paymodel = [BTTUsdtWalletModel yy_modelWithJSON:paymentArray.firstObject];
                        NSArray *protocolArray = [paymodel.usdtProtocol componentsSeparatedByString:@";"];
                        NSArray *protocolDetailArray = [protocolArray.firstObject componentsSeparatedByString:@":"];
                        self.selectedProtocol = protocolDetailArray.firstObject;
                        self.protocolArray = protocolArray;
                        
                        [self.walletCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                        
                        return;
                    }
                }
            }
        }
    }];
}

- (void)requestUSDTRate{
    [self showLoading];
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
            if (![result.body isKindOfClass:[NSDictionary class]]) {
                // 后台返回类型不一，全部转成字符串
                [self showError:[NSString stringWithFormat:@"%@", result.head.errMsg]];
                return;
            }
            
            NSError *error;
            CNPayUSDTRateModel *rateModel = [CNPayUSDTRateModel yy_modelWithJSON:result.body];
            if (error && !rateModel) {
                [self showError:@"操作失败！请联系客户，或者稍后重试!"];
                return;
            }
            
            NSArray *rateArray = [rateModel.rate componentsSeparatedByString:@"."];
            
            NSString *rateDetail =rateArray.lastObject;
            if (rateDetail.length>2) {
                rateDetail = [rateDetail substringToIndex:2];
            }
            NSString *rate = [NSString stringWithFormat:@"%@.%@",rateArray.firstObject,rateDetail];
            self.usdtRate = [[NSDecimalNumber decimalNumberWithString:rate] doubleValue];
            self.moneyTextField.text = self.selectedMoney;
            CGFloat rmbCash = [self.moneyTextField.text integerValue] * self.usdtRate;
            NSString *cnyStr = [NSString stringWithFormat:@"%.3f",rmbCash];
            self.usdtLabel.text = [cnyStr substringWithRange:NSMakeRange(0, cnyStr.length-1)];
            
            [self handleRateLabelShowWithRate:[NSString stringWithFormat:@"%@.%@",rateArray.firstObject,rateDetail]];
        }
    }];
}

- (void)handleRateLabelShowWithRate:(NSString *)rate{
    NSString *str = [NSString stringWithFormat:@"当前参考汇率：1 USDT=%@ CNY，实际请以到账时为准",rate];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrStr addAttribute:NSForegroundColorAttributeName
    value:[UIColor whiteColor]
    range:NSMakeRange(7, 11+rate.length)];
    
    _usdtTipLabel.attributedText = attrStr;
    
}

- (void)saveImgtoXc{
    weakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存支付二维码到相册" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [weakSelf cropThePasswordView];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)cropThePasswordView {
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.secondView.bounds.size, NO, 0);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [self.secondView.layer renderInContext:ctx];
    //iOS7+ 推荐使用的方法，代替上述方法
    // [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    // 保存相册
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
}

- (void)dowloadBfbApp{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.bitoll.com/ios.html"]];
}

- (void)setupView{
    self.view.backgroundColor = kBlackBackgroundColor;
    self.choseMoneyView.layer.backgroundColor = [[UIColor colorWithRed:41.0f/255.0f green:45.0f/255.0f blue:54.0f/255.0f alpha:1.0f] CGColor];
    self.walletCollectionView.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 220);
    [self.choseMoneyView addSubview:self.walletCollectionView];
    
    
    _secondView.layer.backgroundColor = kBlackBackgroundColor.CGColor;
    _secondMoneyView.layer.backgroundColor = kBlackLightColor.CGColor;
    _secondArriveView.layer.backgroundColor = kBlackLightColor.CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dowloadBfbApp)];
    [self.dcboxDownload addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImgtoXc)];
    [self.qrcodeView addGestureRecognizer:longpress];
    
    _infoView.layer.backgroundColor = kBlackForgroundColor.CGColor;
    
    _saveView.backgroundColor = kBlackLightColor;
    
    _commitBtn.layer.cornerRadius = 5;
    _commitBtn.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
    _commitBtn.alpha = 1;
    if (self.bfbNoteImg.isHidden) {
        [self.commitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.usdtTipLabel.mas_bottom).offset(10);
        }];
    } else {
        [self.commitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.usdtTipLabel.mas_bottom).offset(40);
        }];
    }
    _saveFinishBtn.layer.cornerRadius = 5;
    _saveFinishBtn.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
    _saveFinishBtn.alpha = 1;

    //Gradient 0 fill for 圆角矩形 11
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 5;
    gradientLayer0.frame =CGRectMake(0, 0, SCREEN_WIDTH-30, 44);
    gradientLayer0.colors = @[
        (id)[UIColor colorWithRed:247.0f/255.0f green:249.0f/255.0f blue:82.0f/255.0f alpha:1.0f].CGColor,
        (id)[UIColor colorWithRed:242.0f/255.0f green:218.0f/255.0f blue:15.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(1, 1)];
    [gradientLayer0 setEndPoint:CGPointMake(0, 0)];
    [_commitBtn.layer addSublayer:gradientLayer0];
    
    CAGradientLayer *gradientLayer1 = [[CAGradientLayer alloc] init];
    gradientLayer1.cornerRadius = 5;
    gradientLayer1.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 44);
    gradientLayer1.colors = @[
        (id)[UIColor colorWithRed:247.0f/255.0f green:249.0f/255.0f blue:82.0f/255.0f alpha:1.0f].CGColor,
        (id)[UIColor colorWithRed:242.0f/255.0f green:218.0f/255.0f blue:15.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer1.locations = @[@0, @1];
    [gradientLayer1 setStartPoint:CGPointMake(1, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0, 0)];
    [_saveFinishBtn.layer addSublayer:gradientLayer1];
    
    UIView *sepratorView = [[UIView alloc] initWithFrame:CGRectMake(15, 44, SCREEN_WIDTH-15, 1)];
    sepratorView.layer.backgroundColor = [[UIColor colorWithRed:74.0f/255.0f green:77.0f/255.0f blue:85.0f/255.0f alpha:1.0f] CGColor];
    sepratorView.alpha = 1;

    CALayer *solidLayer0 = [[CALayer alloc] init];
    solidLayer0.frame = sepratorView.bounds;
    solidLayer0.backgroundColor = [[UIColor colorWithRed:54.0f/255.0f green:54.0f/255.0f blue:76.0f/255.0f alpha:1.0f] CGColor];
    [sepratorView.layer addSublayer:solidLayer0];
    [_saveView addSubview:sepratorView];
    
    [self handleRateLabelShowWithRate:@"7.0000"];
        
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入充值金额" attributes:
    @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                 NSFontAttributeName:_moneyTextField.font
         }];
    _moneyTextField.attributedPlaceholder = attrString;
    _moneyTextField.delegate = self;
    
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        self.arriveView.hidden = YES;
        self.usdtTipLabel.hidden = YES;
        sepratorView.hidden = YES;
        [self.saveView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
        }];
        [self.commitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.usdtTipLabel).offset(10);
        }];
    }
}

- (IBAction)saveFinishBtn_clikc:(id)sender {
    self.infoView.hidden = NO;
    self.secondView.hidden = YES;
    [self popToRootViewController];
}

- (IBAction)nextBtn_click:(id)sender {
    [self.view endEditing:YES];
    if ([_moneyTextField.text doubleValue]==0||_moneyTextField.text.length==0) {
        [self showError:@"请输入需要存款的金额"];
    }else if (_bfbModel.minAmount!=nil&&_bfbModel.maxAmount!=nil){
        if ([_moneyTextField.text doubleValue]<[_bfbModel.minAmount doubleValue]||[_moneyTextField.text doubleValue]>[_bfbModel.maxAmount doubleValue]){
            [self showError:[NSString stringWithFormat:@"请输入%@-%@的存款金额",_bfbModel.minAmount,_bfbModel.maxAmount]];
        }else{
            [self createOnlineOrdersWithPayType:[_bfbModel.payType integerValue]];
        }
    }else{
        [self createOnlineOrdersWithPayType:[_bfbModel.payType integerValue]];
    }
}

- (void)requestBuyUsdtLink{
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTBuyUSDTLINK paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSString *link = [NSString stringWithFormat:@"%@",result.body[@"payUrl"]];
            self.buyUsdtLink = link;
        }
    }];
}


- (void)createOnlineOrdersWithPayType:(NSInteger)payType{
    [self showLoading];
    NSDictionary *params = @{
        @"amount":_moneyTextField.text,
        @"payType":@(payType),
        @"currency":@"USDT",
        @"loginName":[IVNetwork savedUserInfo].loginName,
        @"protocol" : self.selectedProtocol
    };
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTCreateOnlineOrderV2 paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSString *address = result.body[@"address"];
            self.infoView.hidden = YES;
            self.secondView.hidden = NO;
            [self.qrcodeView setImage:[PublicMethod QRCodeMethod:address]];
            
            weakSelf.secondMoneyLabel.text = weakSelf.moneyTextField.text;
            CGFloat rmbCash = [weakSelf.moneyTextField.text integerValue] * weakSelf.usdtRate;
            NSString *cnyStr = [NSString stringWithFormat:@"%.3f",rmbCash];
            weakSelf.secondArriveLabel.text = [cnyStr substringWithRange:NSMakeRange(0, cnyStr.length-1)];
            if (![[IVNetwork savedUserInfo].uiMode isEqualToString:@"CNY"]) {
                weakSelf.secondArriveView.hidden = YES;
            }
            if ([[UIApplication sharedApplication]
              canOpenURL:[NSURL URLWithString:address]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:address]];
              
            }else{
            }
            
        }else{
            [self showError:result.head.errMsg];
        }
    }];
}

- (void)requestPayDetailUrl:(NSString *)url{
    //初始化一个AFHTTPSessionManager
    [self showLoading];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideLoading];
        NSDictionary *json = responseObject;
        NSString *imgQrcode = [json valueForKey:@"imgQrcode"];
        NSString *payUrl = [imgQrcode stringByReplacingOccurrencesOfString:@"gz://" withString:@"bitoll://"];
        if ([[UIApplication sharedApplication]
          canOpenURL:[NSURL URLWithString:payUrl]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:payUrl]];
            [self popToRootViewController];
          
        }else{
            [self dowloadBfbApp];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (IBAction)moneyTextFieldDidchange:(id)sender {
    if (_moneyTextField.text.length>0) {
        CGFloat rmbCash = [_moneyTextField.text integerValue] * self.usdtRate;
        NSString *cnyStr = [NSString stringWithFormat:@"%.3f",rmbCash];
        _usdtLabel.text = [cnyStr substringWithRange:NSMakeRange(0, cnyStr.length-1)];
    }else{
        _usdtLabel.text = @"0";
    }
    self.selectedMoney = _moneyTextField.text;
    [self.walletCollectionView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if (range.length >= 1) { // 删除数据, 都允许删除
        return YES;
    }
        if (![self checkDecimal:[textField.text stringByAppendingString:string]]){
          
            if (textField.text.length > 0 && [string isEqualToString:@"."] && ![textField.text containsString:@"."]) {
                return YES;
            }
            
            return NO;
            
        }
    return YES;
}


#pragma mark - 正则表达式

/**
 判断是否是两位小数

 @param str 字符串
 @return yes/no
 */
- (BOOL)checkDecimal:(NSString *)str
{
    NSString *regex = [self.selectedProtocol isEqualToString:@"OMNI"] ? @"^[0-9]+(\\.[0-9]{1,8})?$" : @"^[0-9]+(\\.[0-9]{1,6})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if([pred evaluateWithObject: str])
    {
        return YES;
    }else{
        return NO;
    }
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return self.protocolArray.count;
    }else{
        return self.moneyArray.count;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedMoney = self.moneyArray[indexPath.row];
    _moneyTextField.text = self.selectedMoney;
    CGFloat rmbCash = [_moneyTextField.text integerValue] * self.usdtRate;
    NSString *cnyStr = [NSString stringWithFormat:@"%.3f",rmbCash];
    _usdtLabel.text = [cnyStr substringWithRange:NSMakeRange(0, cnyStr.length-1)];
    [UIView performWithoutAnimation:^{
        [self.walletCollectionView reloadData];
    }];
            
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        USDTWalletCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"USDTWalletCollectionCell" forIndexPath:indexPath];
        NSArray *protocolDetailArray = [self.protocolArray[indexPath.row] componentsSeparatedByString:@":"];
        NSString *title = protocolDetailArray.firstObject;
        [cell setCellWithName:title imageName:@""];
        [cell setItemSelected:[title isEqualToString:self.selectedProtocol]];
        return cell;
    }else{
        
    }
    BTTBitollChoseMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBitollChoseMoneyCell" forIndexPath:indexPath];
    [cell setCellWithName:self.moneyArray[indexPath.row]];
    [cell setItemSelected:[self.moneyArray[indexPath.row] isEqualToString:self.selectedMoney]];
    return cell;
}
- (IBAction)onekeyBuyUsdt:(id)sender {
    USDTBuyController * vc = [[USDTBuyController alloc] init];
    [self pushViewController:vc];
//    if (self.buyUsdtLink!=nil&&![self.buyUsdtLink isEqualToString:@""]) {
//        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
//        vc.title = @"一键买币";
//        vc.webConfigModel.theme = @"outside";
//        vc.webConfigModel.newView = YES;
//        vc.webConfigModel.url = self.buyUsdtLink;
//        [self pushViewController:vc];
//    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                withReuseIdentifier:@"UICollectionViewHeader"
                                                                                       forIndexPath:indexPath];
    for (UIView *view in headView.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.section == 0) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 60, 14)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"协议";
        [headView addSubview:titleLabel];

        UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, SCREEN_WIDTH-90, 14)];
        noticeLabel.textColor = COLOR_RGBA(129, 135, 145, 1);
        noticeLabel.font = [UIFont systemFontOfSize:12];
        noticeLabel.text = @" ";
        headView.userInteractionEnabled = false;
        [headView addSubview:noticeLabel];
        return headView;
    } else if ([IVNetwork savedUserInfo].dcboxNum == 0) {
        UILabel *noticeLabel = [[UILabel alloc]init];
        noticeLabel.text = @"点击绑定小金库存款，到账更快哦";
        noticeLabel.textColor = [UIColor colorWithRed: 0.24 green: 0.60 blue: 0.97 alpha: 1.00];
        noticeLabel.font = [UIFont systemFontOfSize:12];
        CGSize size = [noticeLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 14)];
        noticeLabel.frame = CGRectMake(SCREEN_WIDTH-size.width-30, 15, size.width, 14);
        [headView addSubview:noticeLabel];
        
        headView.userInteractionEnabled = true;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToBind)];
        tap.numberOfTapsRequired = 1;
        [headView addGestureRecognizer:tap];
        return headView;
    } else {
        UIView *view = [[UIView alloc]init];
        [headView addSubview:view];
        return headView;
    }
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH-30, 44);
}

-(void)goToBind {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoCardInfoNotification" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.infoView.hidden = NO;
    self.secondView.hidden = YES;
}

@end
