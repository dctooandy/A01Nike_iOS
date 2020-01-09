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
#import "BTTMeMainModel.h"

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


@property (nonatomic, assign) NSInteger defaultChannel;
@property (nonatomic, assign) BOOL hasDefaultChannel;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) AMSegmentViewController *segmentVC;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSMutableArray *payments;

@property (nonatomic, strong) CNPayContainerVC *payChannelVC;

@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation CNPayVC


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithChannel:(NSInteger)channel channelArray:(NSArray *)channelArray{
    if (self = [super init]) {
        self.defaultChannel = channel;
        self.hasDefaultChannel = YES;
        [self fetchChannelSucessHandler:channelArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBlackBackgroundColor;
    self.payScrollView.backgroundColor = kBlackBackgroundColor;
    self.contentWidth.constant = [UIScreen mainScreen].bounds.size.width;
    [self.payCollectionView registerNib:[UINib nibWithNibName:kChannelCellIndentifier bundle:nil] forCellWithReuseIdentifier:kChannelCellIndentifier];
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


/// 请求数据处理
- (void)fetchChannelSucessHandler:(NSArray *)channelArray {
    _payments = [NSMutableArray array];
        
    [_payments addObjectsFromArray:channelArray];
    /// 界面显示
    [self setupChannelView];
}


/**
 构建展示视图
 */
- (void)setupChannelView {
    
    /// 如果不存在已经打开的支付渠道则展示提示页面
    if (_payments.count == 0) {
        [self.view bringSubviewToFront:self.alertLabel];
        
        return;
    }
    _alertLabel.hidden = YES;
    
    _currentSelectedIndex = 0;
    BTTMeMainModel *channelModel = _payments.firstObject;
    
    // 有默认选择默认的
    if (_hasDefaultChannel) {
        for (int i = 0; i < _payments.count; i++) {
            BTTMeMainModel *model = _payments[i];
            if (model.paymentType == self.defaultChannel) {
                channelModel = model;
                _currentSelectedIndex = i;
                break;
            }
        }
    }
    self.title = channelModel.paymentName;
//    BOOL savetimes = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTSaveMoneyTimesKey] integerValue];
//    if ([channelModel.channelName isEqualToString:@"支付宝/微信/QQ/京东"] && savetimes) {
//        self.title = @"支付宝/微信/QQ/京东WAP";
//    }else if (channelModel.payChannel == CNPayChannelUSDT){
//        self.title = @"泰达币-USDT";
//    } else {
//        self.title = channelModel.channelName;
//    }
//    self.selectedIcon = channelModel.selectedIcon;
    
    /// 存在已经打开的支付渠道
    if (_segmentVC) {
        [_segmentVC.view removeFromSuperview];
    }
    [_payCollectionView reloadData];
    [self.payCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentSelectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channelModel.paymentType];
    _payChannelVC.payments = @[channelModel.payModel];
    _segmentVC = [[AMSegmentViewController alloc] initWithViewController:_payChannelVC];
    [self.stepView addSubview:_segmentVC.view];
    [_segmentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.payments.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CNPayChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kChannelCellIndentifier forIndexPath:indexPath];
    
    BTTMeMainModel *channel = [_payments objectAtIndex:indexPath.row];
    BOOL savetimes = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTSaveMoneyTimesKey] integerValue];
    if ([channel.name isEqualToString:@"微信/QQ/京东"] && savetimes) {
        cell.titleLb.text = @"支付宝/微信/QQ/京东";
        cell.titleLb.font = [UIFont boldSystemFontOfSize:11];
    } else {
        cell.titleLb.text = channel.name;
        cell.titleLb.font = [UIFont boldSystemFontOfSize:13];
    }
    
    if (channel.paymentType==99){
        cell.channelIV.image = [UIImage imageNamed:@"me_usdt"];
    }else{
//        cell.channelIV.image = [UIImage imageNamed:channel.selectedIcon];
    }
    
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
//    CNPayChannelModel *channel = [_payChannels objectAtIndex:indexPath.row];
//    //TODO:
////    if ([IVHttpManager shareManager].userInfoModel.starLevel == 0 && (![IVNetwork userInfo].verify_code.length || ![IVNetwork userInfo].real_name.length)) {
//    if ((![IVNetwork userInfo].verify_code.length || ![IVNetwork userInfo].real_name.length)) {
//        if (channel.payChannel == CNPayChannelBQFast || channel.payChannel == CNPayChannelBQWechat || channel.payChannel == CNPayChannelBQAli || channel.payChannel == CNPayChannelDeposit) {
//            BTTCompleteMeterialController *personInfo = [[BTTCompleteMeterialController alloc] init];
//            [self.navigationController pushViewController:personInfo animated:YES];
//            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//            [collectionView reloadData];
//            return;
//        }
//    }
//    [self removeBankView];
//    self.currentSelectedIndex = indexPath.row;
//    [self.payCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channel.payments.firstObject.payType];
//    _payChannelVC.payments = channel.payments;
//    BOOL savetimes = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTSaveMoneyTimesKey] integerValue];
//    if ([channel.channelName isEqualToString:@"微信/QQ/京东WAP"] && savetimes) {
//        self.title = @"支付宝/微信/QQ/京东WAP";
//    } else {
//        if (channel.payChannel==CNPayChannelUSDT) {
//            self.title = @"泰达币-USDT";
//        }else{
//            self.title = channel.channelName;
//        }
//    }
//    self.selectedIcon = channel.selectedIcon;
//    [self.segmentVC addOrUpdateDisplayViewController:_payChannelVC];
    
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
