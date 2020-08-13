//
//  USDTBuyController.m
//  Hybird_A01
//
//  Created by Jairo on 12/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "USDTBuyController.h"
#import "OTCInsideModel.h"
#import "OTCInsideCell.h"

@interface USDTBuyController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * walletCollectionView;
@property (nonatomic, strong) NSArray * bankList;
@property (nonatomic, strong) UILabel * bitBaseTitleLab;
@end

@implementation USDTBuyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = false;
    [self setUpView];
    [self requestBankList];
}

- (void)requestBankList{
    [self showLoading];
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTQueryCounterList paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            weakSelf.bankList = result.body;
            
            for (int i = 0; i < weakSelf.bankList.count; i++) {
                OTCInsideModel * model = [OTCInsideModel yy_modelWithJSON:weakSelf.bankList[i]];
                if ([model.otcMarketName isEqualToString:@"bitbase"]) {
                    weakSelf.bitBaseTitleLab.hidden = false;
                }
            }
            [weakSelf.walletCollectionView reloadData];
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
    
    CGSize size = [self.bitBaseTitleLab sizeThatFits:CGSizeMake(SCREEN_WIDTH-15*2, MAXFLOAT)];
    [buyView addSubview:self.bitBaseTitleLab];
    [self.bitBaseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(size.width);
        make.height.offset(size.height);
        make.centerX.equalTo(buyView);
        make.top.equalTo(buyView).offset(15);
    }];
    
    [buyView addSubview:self.walletCollectionView];
    [self.walletCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bitBaseTitleLab.mas_bottom).offset(15);
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
    OTCInsideModel *model = [OTCInsideModel yy_modelWithJSON:self.bankList[indexPath.row]];
    cell.recommendTagImg.hidden = ![model.otcMarketName isEqualToString:@"bitbase"];
    if ([model.otcMarketName isEqualToString:@"bitbase"]) {
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
        //注册 cell  为了cell的重用机制  使用NIB  也可以使用代码 registerClass xxxx
        [_walletCollectionView registerClass:[OTCInsideCell class] forCellWithReuseIdentifier:@"OTCInsideCell"];
    }
    return _walletCollectionView;
}

-(UILabel *)bitBaseTitleLab {
    if (!_bitBaseTitleLab) {
        _bitBaseTitleLab = [[UILabel alloc] init];
        _bitBaseTitleLab.text = @"点击BitBase存款(支持文信, 支付宝, 银联)金额将直接存入您的游戏帐号";
        _bitBaseTitleLab.textColor = [UIColor redColor];
        _bitBaseTitleLab.font = [UIFont systemFontOfSize:17];
        _bitBaseTitleLab.textAlignment = NSTextAlignmentCenter;
        _bitBaseTitleLab.numberOfLines = 0;
        _bitBaseTitleLab.hidden = true;
    }
    return _bitBaseTitleLab;
}

@end
