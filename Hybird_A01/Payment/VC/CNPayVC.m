//
//  CNPayVC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayVC.h"
#import "AMSegmentViewController.h"
#import "CNPayContainerVC.h"

#import "CNPayChannelCell.h"
#import "CNPaymentModel.h"
#import "CNPayRequestManager.h"
#import "CNPayConstant.h"
#import "CNPayBankView.h"

/// 顶部渠道单元尺寸
#define kPayChannelItemSize CGSizeMake(102, 132)
#define kChannelCellIndentifier   @"CNPayChannelCell"

@interface CNPayVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign) CNPayChannel defaultChannel;
@property (nonatomic, strong) UIScrollView *payScrollView;
@property (nonatomic, strong) UICollectionView *payCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) AMSegmentViewController *segmentVC;
@property (nonatomic, strong) CNPayBankView *bankView;

@property (nonatomic, strong) NSMutableArray<CNPayChannelModel *> *payChannels;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, assign) BOOL hasDefaultChannel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation CNPayVC

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
    [self fetchPayChannels];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setContentViewHeight:(CGFloat)height fullScreen:(BOOL)full {
    if (full) {
        self.payCollectionView.hidden = YES;
        self.payCollectionView.frame = CGRectZero;
        if (height < self.view.frame.size.height) {
            height = self.view.frame.size.height;
        }
    } else {
        self.payCollectionView.hidden = NO;
        self.payCollectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, kPayChannelItemSize.height);
    }
    
    // 调整scrollview内容
    CGRect frame = self.contentView.frame;
    frame.size.height = height;
    self.contentView.frame = frame;
    self.payScrollView.contentSize = frame.size;
    [self.payScrollView scrollsToTop];
}

- (void)addBankView {
    if (_bankView) {
        [self.bankView setHidden:NO];
        [self.bankView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@180);
        }];
    } else {
        [_payCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bankView.mas_bottom).offset(0);
            make.left.right.equalTo(@0);
            make.height.equalTo(@(kPayChannelItemSize.height));
        }];
    }
}

- (void)removeBankView {
    if (!_bankView) {
        return;
    }
    [self.bankView setHidden:YES];
    [self.bankView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}

/// 请求支付渠道信息
- (void)fetchPayChannels {
    __weak typeof(self) weakSelf =  self;
    [self.activityView startAnimating];
    [CNPayRequestManager queryAllChannelCompleteHandler:^(IVRequestResultModel *result, id response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.activityView stopAnimating];
        if (result.status) {
            [strongSelf fetchChannelSucessHandler:response];
            return;
        }
        // 失败处理
        [strongSelf fetchChannelFailHandler];
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
    CNPayChannelModel *JD = [[CNPayChannelModel alloc] init];
    JD.payChannel = CNPayChannelJDApp;
    JD.payments = [[NSArray alloc] initWithObjects:
                   payments[CNPaymentJDApp], nil];
    
    
    /// 扫码
    CNPayChannelModel *QR = [[CNPayChannelModel alloc] init];
    QR.payChannel = CNPayChannelQR;
    QR.payments = [[NSArray alloc] initWithObjects:
                   payments[CNPaymentWechatQR],
                   payments[CNPaymentAliQR],
                   payments[CNPaymentQQQR],
                   payments[CNPaymentUnionQR],
                   payments[CNPaymentWechatApp],
                   payments[CNPaymentQQApp],
                   nil];
    
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
    
    /// 币宝支付
    CNPayChannelModel *coin = [[CNPayChannelModel alloc] init];
    coin.payChannel = CNPayChannelCoin;
    coin.payments = [[NSArray alloc] initWithObjects:
                    payments[CNPaymentCoin], nil];
    
    NSArray *array = @[BQFast,BQWeChat,BQAli,deposit,ali,online,QR,unionPay,card,BTC,JD,barCode,coin];
    
    // 没开启的渠道不显示
    for (CNPayChannelModel *channel in array) {
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
    
    CNPayChannel payChannel = channelModel.payChannel;
    self.title = channelModel.channelName;
    self.selectedIcon = channelModel.selectedIcon;
    
    /// 存在已经打开的支付渠道
    if (_segmentVC) {
        [_payCollectionView reloadData];
        [_segmentVC.view removeFromSuperview];
    }
    
    [self.payCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentSelectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    CNPayContainerVC *payChannelVC = [[CNPayContainerVC alloc] initWithPayChannel:payChannel];
    payChannelVC.payments = _payChannels[_currentSelectedIndex].payments;
    _segmentVC = [[AMSegmentViewController alloc] initWithViewController:payChannelVC];
    [self.contentView addSubview:_segmentVC.view];
    [_segmentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.top.equalTo(self.payCollectionView.mas_bottom).offset(0);
    }];
}

#pragma mark- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.payChannels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CNPayChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kChannelCellIndentifier forIndexPath:indexPath];
    
    CNPayChannelModel *channel = [_payChannels objectAtIndex:indexPath.row];
    cell.titleLb.text = channel.channelName;
    cell.channelIV.image = [UIImage imageNamed:channel.selectedIcon];
    
    // 默认选中第一个可以支付的渠道
    if (indexPath.row == _currentSelectedIndex) {
        cell.selected = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == _currentSelectedIndex) {
        return;
    }
    [self removeBankView];
    self.currentSelectedIndex = indexPath.row;
    [self.payCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    CNPayChannelModel *channel = [_payChannels objectAtIndex:indexPath.row];
    CNPayContainerVC *payChannelVC = [[CNPayContainerVC alloc] initWithPayChannel:channel.payChannel];
    payChannelVC.payments = channel.payments;
    self.title = channel.channelName;
    self.selectedIcon = channel.selectedIcon;
    [self.segmentVC addOrUpdateDisplayViewController:payChannelVC];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kPayChannelItemSize;
}

#pragma mark - Getter

- (UIScrollView *)payScrollView {
    if (!_payScrollView) {
        _payScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _payScrollView.contentSize = self.view.bounds.size;
        _payScrollView.backgroundColor = kBlackBackgroundColor;
        [self.view addSubview:_payScrollView];
    }
    return _payScrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.payScrollView.bounds];
        _contentView.backgroundColor = kBlackBackgroundColor;
        [self.payScrollView addSubview:_contentView];
    }
    return _contentView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setMinimumInteritemSpacing:0.0f];
        [layout setMinimumLineSpacing:5.0f];
        [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = kPayChannelItemSize;
        _layout = layout;
    }
    return _layout;
}

- (UICollectionView *)payCollectionView {
    if (!_payCollectionView) {
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, kPayChannelItemSize.height);
        _payCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.layout];
        _payCollectionView.delegate = self;
        _payCollectionView.dataSource = self;
        _payCollectionView.backgroundColor = kBlackForgroundColor;
        _payCollectionView.showsVerticalScrollIndicator = NO;
        _payCollectionView.showsHorizontalScrollIndicator = NO;
        _payCollectionView.contentInset = UIEdgeInsetsMake(40, 10, 15, 10);
        [self.contentView addSubview:_payCollectionView];
        
         [_payCollectionView registerNib:[UINib nibWithNibName:kChannelCellIndentifier bundle:nil] forCellWithReuseIdentifier:kChannelCellIndentifier];
    }
    return _payCollectionView;
}

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
        CGPoint center = self.view.center;
        _activityView.center = CGPointMake(center.x, center.y-64);
        [self.view addSubview:_activityView];
    }
    return _activityView;
}

- (CNPayBankView *)bankView {
    if (!_bankView) {
        _bankView = [[CNPayBankView alloc] init];
        [self.contentView addSubview:_bankView];
        [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(@0);
            make.height.equalTo(@180);
        }];
    }
    return _bankView;
}

#pragma mark - OverWrite

- (void)goToBack {
//    [self removeBankView];
//    UIViewController *vc = self.segmentVC.childViewControllers.firstObject;
//    if (vc && [vc isKindOfClass:[CNPayContainerVC class]]) {
//        if ([((CNPayContainerVC *)vc) canPopViewController]) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } else {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}
@end
