//
//  CNPayVC.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/29.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayVC.h"
#import "AMSegmentViewController.h"
#import "CNPayContainerVC.h"

#import "CNPayChannelCell.h"
#import "CNPaymentModel.h"
#import "CNPayRequestManager.h"
#import "CNPayConstant.h"
#import "CNPayBankView.h"
#import "CNPayDepositNameModel.h"
#import "BTTCompleteMeterialController.h"

/// 顶部渠道单元尺寸
#define kPayChannelItemSize CGSizeMake(102, 132)
#define kChannelCellIndentifier   @"CNPayChannelCell"

@interface CNPayVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *payScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

@property (weak, nonatomic) IBOutlet CNPayBankView *bankView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankViewHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *payCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payCollectionViewHeight;

@property (weak, nonatomic) IBOutlet UIView *stepView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepViewHeight;


@property (nonatomic, assign) CNPayChannel defaultChannel;
@property (nonatomic, assign) BOOL hasDefaultChannel;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) AMSegmentViewController *segmentVC;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSMutableArray <CNPayChannelModel *> *payChannels;

@property (nonatomic, strong) CNPayContainerVC *payChannelVC;

@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation CNPayVC


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithChannel:(CNPayChannel)channel {
    if (self = [super init]) {
        self.defaultChannel = channel;
        self.hasDefaultChannel = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBlackBackgroundColor;
    self.payScrollView.backgroundColor = kBlackBackgroundColor;
    self.contentWidth.constant = [UIScreen mainScreen].bounds.size.width;
    [self.payCollectionView registerNib:[UINib nibWithNibName:kChannelCellIndentifier bundle:nil] forCellWithReuseIdentifier:kChannelCellIndentifier];
    [self fetchPayChannels];
    [self registerNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIItems:) name:@"BTTUpdateSaveMoneyUINotification" object:nil];
}

- (void)updateUIItems:(NSNotification *)notifi  {
    NSLog(@"%@",notifi.object);
    _payChannelVC.segmentVC.items = notifi.object;
    _segmentVC.items = notifi.object;
    [self.segmentVC addOrUpdateDisplayViewController:_payChannelVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isFirstLoad) {
        [[CNTimeLog shareInstance] endRecordTime:CNEventPayLaunch];
        _isFirstLoad = YES;
    }
}

- (void)setContentViewHeight:(CGFloat)height fullScreen:(BOOL)full {
    self.payCollectionView.hidden = full;
    self.payCollectionViewHeight.constant = full ? 0: 142;
    self.stepViewHeight.constant = height;
    [self.payScrollView scrollsToTop];
}

- (void)addBankView {
    [self getManualDeposit];
}

- (void)removeBankView {
    self.bankView.hidden = YES;
    self.bankViewHeight.constant = 0;
}

/// 请求支付渠道信息
- (void)fetchPayChannels {
    __weak typeof(self) weakSelf =  self;
    [self.activityView startAnimating];
    [CNPayRequestManager queryAllChannelCompleteHandler:^(id  _Nullable response, NSError * _Nullable error) {
#warning 调试接口
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.activityView stopAnimating];
//        if (result.status) {
//            [strongSelf fetchChannelSucessHandler:response];
//            return;
//        }
//        // 失败处理
//        [strongSelf fetchChannelFailHandler];
    }];
 
}

/// 请求数据处理
- (void)fetchChannelSucessHandler:(id)obj {
    if ([obj isKindOfClass:[NSArray class]] && [(NSArray *)obj count] == kPayTypeTotalCount) {
        
        NSArray *objArray = (NSArray *)obj;
        NSMutableArray<CNPaymentModel *> *payments = [NSMutableArray array];
        
        for (int i = 0; i< kPayTypeTotalCount; i++) {
            /// 数据解析
            NSError *error;
            CNPaymentModel *model = [[CNPaymentModel alloc] initWithDictionary:(NSDictionary *)objArray[i] error:&error];
            if (error && !model) {
                model = [[CNPaymentModel alloc] init];
                model.isAvailable = NO;
            }
            model.paymentType = (CNPaymentType)i;
            [payments addObject:model];
        }
        
        /// 数据拼接处理
        _payChannels = [self jointPayChannels:payments];
        /// 界面显示
        [self setupChannelView];
        
    } else {
        /// 数据异常处理
        [self fetchChannelFailHandler];
    }
}

/**
 构建支付渠道
 根据产品经理要求:进行固定顺序的数据构建
 
 @param payments 支持的支付方式
 */
- (NSMutableArray<CNPayChannelModel *> *)jointPayChannels:(NSArray<CNPaymentModel *> *)payments {
    
    NSMutableArray <CNPayChannelModel *> *channels = [NSMutableArray array];
    
    /// 在线支付
    CNPayChannelModel *online = [[CNPayChannelModel alloc] init];
    online.payChannel = CNPayChannelOnline;
    online.payments = [[NSArray alloc] initWithObjects:
                       payments[CNPaymentOnline], nil];
    
    /// 点卡
    CNPayChannelModel *card = [[CNPayChannelModel alloc] init];
    card.payChannel = CNPayChannelCard;
    card.payments = [[NSArray alloc] initWithObjects:
                     payments[CNPaymentCard], nil];
    
    
    /// 手工存款
    CNPayChannelModel *deposit = [[CNPayChannelModel alloc] init];
    deposit.payChannel = CNPayChannelDeposit;
    deposit.payments = [[NSArray alloc] initWithObjects:
                        payments[CNPaymentDeposit], nil];
    
    
    /// 比特币支付
    CNPayChannelModel *BTC = [[CNPayChannelModel alloc] init];
    BTC.payChannel = CNPayChannelBTC;
    BTC.payments = [[NSArray alloc] initWithObjects:
                    payments[CNPaymentBTC], nil];
    
    
    /// 支付宝支付
    CNPayChannelModel *ali = [[CNPayChannelModel alloc] init];
    ali.payChannel = CNPayChannelAliApp;
    ali.payments = [[NSArray alloc] initWithObjects:
                    payments[CNPaymentAliApp], nil];
    
    
    /// 银联mobile
    CNPayChannelModel *unionPay = [[CNPayChannelModel alloc] init];
    unionPay.payChannel = CNPayChannelUnionApp;
    unionPay.payments = [[NSArray alloc] initWithObjects:
                         payments[CNPaymentUnionApp], nil];
    
    
    /// 京东支付
//    CNPayChannelModel *JD = [[CNPayChannelModel alloc] init];
//    JD.payChannel = CNPayChannelJDApp;
//    JD.payments = [[NSArray alloc] initWithObjects:
//                   payments[CNPaymentJDApp], nil];
    
    
//    /// 扫码
//    CNPayChannelModel *QR = [[CNPayChannelModel alloc] init];
//    QR.payChannel = CNPayChannelWechatQQJDAPP;
//    QR.payments = [[NSArray alloc] initWithObjects:
//                   payments[CNPaymentWechatApp],
//                   payments[CNPaymentQQApp],
//                   payments[CNPaymentJDApp],
//                   nil];
    
    /// BQ 快速
    CNPayChannelModel *BQFast = [[CNPayChannelModel alloc] init];
    BQFast.payChannel = CNPayChannelBQFast;
    BQFast.payments = [[NSArray alloc] initWithObjects:
                       payments[CNPaymentBQFast], nil];
    
    /// BQ WeChat
    CNPayChannelModel *BQWeChat = [[CNPayChannelModel alloc] init];
    BQWeChat.payChannel = CNPayChannelBQWechat;
    BQWeChat.payments = [[NSArray alloc] initWithObjects:
                         payments[CNPaymentBQWechat], nil];
    
    /// BQ Ali
    CNPayChannelModel *BQAli = [[CNPayChannelModel alloc] init];
    BQAli.payChannel = CNPayChannelBQAli;
    BQAli.payments = [[NSArray alloc] initWithObjects:
                      payments[CNPaymentBQAli], nil];
    
    
    /// 微信条码
    CNPayChannelModel *barCode = [[CNPayChannelModel alloc] init];
    barCode.payChannel = CNPayChannelWechatBarCode;
    barCode.payments = [[NSArray alloc] initWithObjects:
                        payments[CNPaymentWechatBarCode], nil];
    
    /// 钻石币支付
    CNPayChannelModel *coin = [[CNPayChannelModel alloc] init];
    coin.payChannel = CNPayChannelCoin;
    coin.payments = [[NSArray alloc] initWithObjects:
                     payments[CNPaymentCoin], nil];
    // 银联扫码
    CNPayChannelModel *unionQR = [[CNPayChannelModel alloc] init];
    unionQR.payChannel = CNPayChannelUnionQR;
    unionQR.payments = [[NSArray alloc] initWithObjects:
                     payments[CNPaymentUnionQR], nil];
    
    // 京东扫码
    CNPayChannelModel *jdQR = [[CNPayChannelModel alloc] init];
    jdQR.payChannel = CNPayChannelJDQR;
    jdQR.payments = [[NSArray alloc] initWithObjects:
                        payments[CNPaymentJDQR], nil];
    
    // 支付宝扫码
    CNPayChannelModel *aliQR = [[CNPayChannelModel alloc] init];
    aliQR.payChannel = CNPayChannelAliQR;
    aliQR.payments = [[NSArray alloc] initWithObjects:
                        payments[CNPaymentAliQR], nil];
    // 微信扫码
    CNPayChannelModel *wxQR = [[CNPayChannelModel alloc] init];
    wxQR.payChannel = CNPayChannelWechatQR;
    wxQR.payments = [[NSArray alloc] initWithObjects:
                      payments[CNPaymentWechatQR], nil];
    
    // QQ扫码
    CNPayChannelModel *qqQR = [[CNPayChannelModel alloc] init];
    qqQR.payChannel = CNPayChannelQQQR;
    qqQR.payments = [[NSArray alloc] initWithObjects:
                     payments[CNPaymentQQQR], nil];
    // 微信/QQ/京东WAP
    BOOL timeMoreTen = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTSaveMoneyTimesKey] integerValue] >= 10 ? YES : NO;
    
    CNPayChannelModel *wap = [[CNPayChannelModel alloc] init];
    wap.payChannel = CNPayChannelWechatQQJDAPP;
    if (timeMoreTen) {
        wap.payments = [[NSArray alloc] initWithObjects:
                        payments[CNPaymentAliApp],
                        payments[CNPaymentWechatApp],
                        payments[CNPaymentQQApp],
                        payments[CNPaymentJDApp],nil];
    } else {
        wap.payments = [[NSArray alloc] initWithObjects:
                        payments[CNPaymentWechatApp],
                        payments[CNPaymentQQApp],
                        payments[CNPaymentJDApp],nil];
    }
    
    CNPayChannelModel *YSF = [[CNPayChannelModel alloc] init];
    YSF.payChannel = CNPayChannelYSFQR;
    YSF.payments = [[NSArray alloc] initWithObjects:
                    payments[CNPaymentYSFQR], nil];
    
    CNPayChannelModel *BS = [[CNPayChannelModel alloc] init];
    BS.payChannel = CNPayChannelBS;
    BS.payments = [[NSArray alloc] initWithObjects:payments[CNPaymentBS], nil];
    
    NSArray *array = nil;
    if (timeMoreTen) {
        array = @[BQFast,BQAli,BQWeChat,deposit,unionQR,aliQR,online,wxQR,jdQR,qqQR,wap,YSF,unionPay,coin,card,BTC,barCode,BS];
    } else {
        array = @[unionQR,jdQR,ali,BQFast,BQWeChat,BQAli,aliQR,wxQR,qqQR,online,deposit,wap,YSF,unionPay,coin,card,BTC,barCode,BS];
    }
    
    // 没开启的渠道不显示
    for (CNPayChannelModel *channel in array) {
        NSLog(@"%@",channel.channelName);
        if (channel.isAvailable) {
            [channels addObject:channel];
            if (channel.payments.count == 1) {
                continue;
            }
            
            // 渠道下没有开启的支付方式不显示
            NSMutableArray *payments = [NSMutableArray array];
            for (CNPaymentModel *payment in channel.payments) {
                if (payment.isAvailable) {
                    [payments addObject:payment];
                }
            }
            channel.payments = payments;
        }
    }
    
    
    return channels;
}

/**
 请求错误处理
 */
- (void)fetchChannelFailHandler {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"访问失败，请点击重试！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"点击重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf fetchPayChannels];
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:retryAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

/**
 构建展示视图
 */
- (void)setupChannelView {
    
    /// 如果不存在已经打开的支付渠道则展示提示页面
    if (_payChannels.count == 0) {
        [self.view bringSubviewToFront:self.alertLabel];
        
        return;
    }
    _alertLabel.hidden = YES;
    
    
    _currentSelectedIndex = 0;
    CNPayChannelModel *channelModel = _payChannels.firstObject;
    
    // 有默认选择默认的
    if (_hasDefaultChannel) {
        for (int i = 0; i < _payChannels.count; i++) {
            CNPayChannelModel *model = _payChannels[i];
            if (model.payChannel == self.defaultChannel) {
                channelModel = model;
                _currentSelectedIndex = i;
                break;
            }
        }
    }
    BOOL savetimes = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTSaveMoneyTimesKey] integerValue];
    if ([channelModel.channelName isEqualToString:@"微信/QQ/京东WAP"] && savetimes) {
        self.title = @"支付宝/微信/QQ/京东WAP";
    } else {
        self.title = channelModel.channelName;
    }
    self.selectedIcon = channelModel.selectedIcon;
    
    /// 存在已经打开的支付渠道
    if (_segmentVC) {
        [_segmentVC.view removeFromSuperview];
    }
    [_payCollectionView reloadData];
    [self.payCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentSelectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channelModel.payments.firstObject.paymentType];
    _payChannelVC.payments = _payChannels[_currentSelectedIndex].payments;
    _segmentVC = [[AMSegmentViewController alloc] initWithViewController:_payChannelVC];
    [self.stepView addSubview:_segmentVC.view];
    [_segmentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.payChannels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CNPayChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kChannelCellIndentifier forIndexPath:indexPath];
    
    CNPayChannelModel *channel = [_payChannels objectAtIndex:indexPath.row];
    BOOL savetimes = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTSaveMoneyTimesKey] integerValue];
    if ([channel.channelName isEqualToString:@"微信/QQ/京东WAP"] && savetimes) {
        cell.titleLb.text = @"支付宝/微信/QQ/京东WAP";
        cell.titleLb.font = [UIFont boldSystemFontOfSize:11];
    } else {
        cell.titleLb.text = channel.channelName;
        cell.titleLb.font = [UIFont boldSystemFontOfSize:13];
    }
    
    cell.channelIV.image = [UIImage imageNamed:channel.selectedIcon];
    
    // 默认选中第一个可以支付的渠道
    if (indexPath.row == _currentSelectedIndex) {
        cell.selected = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //TODO:
    if (indexPath.row == _currentSelectedIndex) {
        return;
    }
    CNPayChannelModel *channel = [_payChannels objectAtIndex:indexPath.row];
    //TODO:
//    if ([IVHttpManager shareManager].userInfoModel.starLevel == 0 && (![IVNetwork userInfo].verify_code.length || ![IVNetwork userInfo].real_name.length)) {
    if ((![IVNetwork userInfo].verify_code.length || ![IVNetwork userInfo].real_name.length)) {
        if (channel.payChannel == CNPayChannelBQFast || channel.payChannel == CNPayChannelBQWechat || channel.payChannel == CNPayChannelBQAli || channel.payChannel == CNPayChannelDeposit) {
            BTTCompleteMeterialController *personInfo = [[BTTCompleteMeterialController alloc] init];
            [self.navigationController pushViewController:personInfo animated:YES];
            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            [collectionView reloadData];
            return;
        }
    }
    [self removeBankView];
    self.currentSelectedIndex = indexPath.row;
    [self.payCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channel.payments.firstObject.paymentType];
    _payChannelVC.payments = channel.payments;
    BOOL savetimes = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTSaveMoneyTimesKey] integerValue];
    if ([channel.channelName isEqualToString:@"微信/QQ/京东WAP"] && savetimes) {
        self.title = @"支付宝/微信/QQ/京东WAP";
    } else {
        self.title = channel.channelName;
    }
    self.selectedIcon = channel.selectedIcon;
    [self.segmentVC addOrUpdateDisplayViewController:_payChannelVC];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kPayChannelItemSize;
}

#pragma mark - Getter

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        alertLabel.text = @"充值方式已经关闭，请联系客服!";
        alertLabel.textColor = [UIColor grayColor];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.font = [UIFont systemFontOfSize:16.0f];
        alertLabel.backgroundColor = kBlackBackgroundColor;
        [self.view addSubview: alertLabel];
        _alertLabel = alertLabel;
    }
    return _alertLabel;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.view addSubview:_activityView];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.equalTo(@(-64));
        }];
    }
    return _activityView;
}

#pragma mark - OverWrite

- (void)goToBack {
    [self removeBankView];
    UIViewController *vc = self.segmentVC.childViewControllers.firstObject;
    if (vc && [vc isKindOfClass:[CNPayContainerVC class]]) {
        if ([((CNPayContainerVC *)vc) canPopViewController]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 获取历史存款人姓名
- (void)getManualDeposit {
    __weak typeof(self) weakSelf = self;
    [CNPayRequestManager paymentGetDepositNameWithType:YES CompleteHandler:^(id  _Nullable response, NSError * _Nullable error) {
#warning 调试接口
//        if (result.status) {
//            [weakSelf configNameView:result.data];
//        }
    }];

}

- (void)configNameView:(NSArray *)array {
    NSArray *modelArray = [CNPayDepositNameModel arrayOfModelsFromDictionaries:array error:nil];
    if (modelArray.count == 0) {
        [self removeBankView];
        return;
    }
    self.bankView.hidden = NO;
    self.bankViewHeight.constant = 180;
    [self.bankView reloadData:modelArray];
    weakSelf(weakSelf);
    self.bankView.deleteHandler = ^{
        [weakSelf removeBankView];
    };
}

@end
