//
//  USDTBuyController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 12/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "USDTBuyController.h"
#import "OTCInsideModel.h"
#import "OTCInsideCell.h"
#import "BTTBindingMobileController.h"

@interface USDTBuyController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * walletCollectionView;
@property (nonatomic, strong) NSMutableArray * bankList;
@property (nonatomic, strong) UILabel * redTitleLab;
@property (nonatomic, strong) NSMutableDictionary * cellDic;
@property (nonatomic, copy) NSString * redTitleBankName;
@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation USDTBuyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellDic = [[NSMutableDictionary alloc] init];
    self.bankList = [[NSMutableArray alloc] init];
    self.navigationController.navigationBarHidden = false;
    self.title = @"购买USDT";
    self.redTitleBankName = @"DEXCHANGE";
    [self setUpView];
    [self requestBankList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isFirstLoad) {
        [CNTimeLog endRecordTime:CNEventPayLaunch];
        _isFirstLoad = YES;
    }
}

- (void)requestBankList {
    [self showLoading];
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTQueryCounterList paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [weakSelf.bankList addObjectsFromArray:result.body];
            
            if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
                [weakSelf loadIsShowBiteBase];
            } else {
                for (int i = 0; i < weakSelf.bankList.count; i++) {
                    OTCInsideModel * model = [OTCInsideModel yy_modelWithJSON:weakSelf.bankList[i]];
                    if ([model.otcMarketName isEqualToString:self.redTitleBankName]) {
                        weakSelf.redTitleLab.hidden = false;
                        [weakSelf.walletCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(weakSelf.redTitleLab).offset(weakSelf.redTitleLab.frame.size.height + 15);
                        }];
                        break;
                    }
                }
                [weakSelf hideLoading];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.walletCollectionView reloadData];
                });
            }
        } else {
            [weakSelf hideLoading];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)loadIsShowBiteBase {
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTIsShowBiteBase paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [weakSelf hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BOOL show = [result.body[@"show"] boolValue];
            if (show) {
                weakSelf.redTitleLab.hidden = false;
                [weakSelf.walletCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.redTitleLab).offset(weakSelf.redTitleLab.frame.size.height + 15);
                }];
            } else {
                for (int i = 0; i < weakSelf.bankList.count; i++) {
                    OTCInsideModel * model = [OTCInsideModel yy_modelWithJSON:weakSelf.bankList[i]];
                    if ([model.otcMarketName isEqualToString:self.redTitleBankName]) {
                        [weakSelf.bankList removeObject:weakSelf.bankList[i]];
                        break;
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.walletCollectionView reloadData];
            });
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)setUpView {
    UIView *buyView = [[UIView alloc]init];
    buyView.backgroundColor = [UIColor colorWithHexString:@"#292d36"];;
    [self.view addSubview:buyView];
    [buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KIsiPhoneX ? 88 : 64);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    CGSize size = [self.redTitleLab sizeThatFits:CGSizeMake(SCREEN_WIDTH-15*2, MAXFLOAT)];
    [buyView addSubview:self.redTitleLab];
    [self.redTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(size.width);
        make.height.offset(size.height);
        make.centerX.equalTo(buyView);
        make.top.equalTo(buyView).offset(15);
    }];
    
    [buyView addSubview:self.walletCollectionView];
    [self.walletCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redTitleLab);
        make.left.equalTo(buyView).offset(15);
        make.bottom.right.equalTo(buyView).offset(-15);
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
    if (model.otcMarketName.length != 0 && [model.otcMarketName isEqualToString:self.redTitleBankName]&&[IVNetwork savedUserInfo].mobileNoBind != 1) {
        BTTBindingMobileController *vc = [[BTTBindingMobileController alloc] init];
        vc.mobileCodeType = BTTSafeVerifyTypeBindMobile;
        vc.showNotice = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
        vc.isWithdrawIn = false;
        [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.otcMarketLink!=nil&&![model.otcMarketLink isEqualToString:@""]) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.title = model.otcMarketName;
        vc.webConfigModel.theme = @"outside";
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.url = model.otcMarketLink;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"OTCInsideCell", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.walletCollectionView registerClass:[OTCInsideCell class]  forCellWithReuseIdentifier:identifier];
    }
    OTCInsideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    OTCInsideModel *model = [OTCInsideModel yy_modelWithJSON:self.bankList[indexPath.row]];
    cell.recommendTagImg.hidden = ![model.otcMarketName isEqualToString:self.redTitleBankName];
    if ([model.otcMarketName isEqualToString:self.redTitleBankName]) {
        [cell setBitbaseBgImg];
    }
    [cell cellConfigJson:model];
    
    return cell;
}

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
    }
    return _walletCollectionView;
}

-(UILabel *)redTitleLab {
    if (!_redTitleLab) {
        _redTitleLab = [[UILabel alloc] init];
        _redTitleLab.text = @"点击Dexchange存款(支持微信, 支付宝, 银联)金额将直接存入您的游戏账号";
        _redTitleLab.textColor = [UIColor redColor];
        _redTitleLab.font = [UIFont systemFontOfSize:17];
        _redTitleLab.textAlignment = NSTextAlignmentCenter;
        _redTitleLab.numberOfLines = 0;
        _redTitleLab.hidden = true;
    }
    return _redTitleLab;
}

@end
