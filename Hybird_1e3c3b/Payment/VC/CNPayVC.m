//
//  CNPayVC.m
//  Hybird_1e3c3b
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
#import "CNMSelectChannelVC.h"
#import "CNMAlertView.h"

/// 顶部渠道单元尺寸
#define kPayChannelItemSize CGSizeMake(102, 132)
#define kChannelCellIndentifier   @"CNPayChannelCell"

@interface CNPayVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *payScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

@property (weak, nonatomic) IBOutlet CNPayBankView *bankView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankViewHeight;

@property (weak, nonatomic) IBOutlet UIView *channelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelViewH;


@property (weak, nonatomic) IBOutlet UIView *stepView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *channelLogo;
@property (weak, nonatomic) IBOutlet UILabel *channelTitle;
@property (weak, nonatomic) IBOutlet UILabel *discountLb;
@property (weak, nonatomic) IBOutlet UIImageView *recommendIcon;


@property (nonatomic, assign) NSInteger defaultChannel;
@property (nonatomic, assign) BOOL hasDefaultChannel;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) AMSegmentViewController *segmentVC;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

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
    self.contentWidth.constant = [UIScreen mainScreen].bounds.size.width-30;
    [self registerNotification];
    [self setupChannelView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isFirstLoad) {
        [CNTimeLog endRecordTime:CNEventPayLaunch];
        _isFirstLoad = YES;
    }
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIItems:) name:@"BTTUpdateSaveMoneyUINotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoKefu) name:@"gotoKefu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoVIPKefu) name:@"gotoVIPKefu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToBack) name:@"gotoBack" object:nil];
}

- (void)updateUIItems:(NSNotification *)notifi  {
    NSLog(@"%@",notifi.object);
    _payChannelVC.segmentVC.items = notifi.object;
    _segmentVC.items = notifi.object;
    [self.segmentVC addOrUpdateDisplayViewController:_payChannelVC];
}

-(void)gotoKefu {
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
        } else {

        }
    }];
}

-(void)gotoVIPKefu {
    [CSVisitChatmanager startWithSuperVC:self extraParam:@{@"userTextTag":@"[贵宾存款] 你好，麻烦给我一个专属存款账号"} finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
        } else {

        }
    }];
}

- (void)setContentViewHeight:(CGFloat)height fullScreen:(BOOL)full {
    self.channelView.hidden = full;
    self.channelViewH.constant = full ? 0: 117;
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
//    [self setupChannelView];
}

- (IBAction)selectChannel:(id)sender {
    CNMSelectChannelVC *vc = [[CNMSelectChannelVC alloc] init];
    vc.payments = self.payments;
    vc.currentSelectedIndex = self.currentSelectedIndex;
    __weak typeof(self) weakSelf = self;
    vc.finish = ^(NSInteger currentSelectedIndex) {
        [weakSelf didSelectChannel:currentSelectedIndex];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateChannelUI:(BTTMeMainModel *)channel {
    self.channelLogo.image = [UIImage imageNamed:channel.iconName];
    self.discountLb.text = (channel.paymentType == CNPaymentFast) ? @"返利1%" : nil;
    self.channelTitle.text = channel.name;
    self.recommendIcon.hidden = (channel.paymentType != CNPaymentFast);
}

- (void)didSelectChannel:(NSInteger)index {
    BTTMeMainModel *channel = [_payments objectAtIndex:index];
    [self updateChannelUI:channel];
    if ([IVNetwork savedUserInfo].starLevel == 0 && ![IVNetwork savedUserInfo].realName.length) {
        if (channel.paymentType == 90 || channel.paymentType == 91 || channel.paymentType == 92 || channel.paymentType == 0) {
            BTTCompleteMeterialController *personInfo = [[BTTCompleteMeterialController alloc] init];
            [self.navigationController pushViewController:personInfo animated:YES];
            return;
        }
    }
    [self removeBankView];
    self.currentSelectedIndex = index;
    
    if (channel.paymentType==6789) {
        _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channel.payModels.firstObject.payType];
        _payChannelVC.payments = channel.payModels;
    } else if (channel.paymentType == CNPaymentVip) {
        _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channel.paymentType];
    } else {
        _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channel.paymentType];
        if (channel.payModel) {
            _payChannelVC.payments = @[channel.payModel];
        }
    }
    _payChannelVC.matchModel = self.matchModel;
    
//    BOOL savetimes = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTSaveMoneyTimesKey] integerValue];
    self.title = channel.name;
    self.selectedIcon = channel.iconName;
    [self.segmentVC addOrUpdateDisplayViewController:_payChannelVC];
    
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
    self.title = channelModel.name;
    self.selectedIcon = channelModel.iconName;
    
    /// 存在已经打开的支付渠道
    if (_segmentVC) {
        [_segmentVC.view removeFromSuperview];
    }
    
    
    if (channelModel.paymentType==6789) {
        _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channelModel.payModels.firstObject.payType];
        _payChannelVC.payments = channelModel.payModels;
    } else if (channelModel.paymentType == CNPaymentVip) {
        _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channelModel.paymentType];
    } else {
        _payChannelVC = [[CNPayContainerVC alloc] initWithPaymentType:channelModel.paymentType];
        if (channelModel.payModel) {
            _payChannelVC.payments = @[channelModel.payModel];
        }
    }
    
    _segmentVC = [[AMSegmentViewController alloc] initWithViewController:_payChannelVC];
    [self.stepView addSubview:_segmentVC.view];
    [_segmentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self didSelectChannel:_currentSelectedIndex];
}

#pragma mark - Getter

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        CGRect frame = self.view.bounds;
        frame.size.width = UIScreen.mainScreen.bounds.size.width;
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:frame];
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
    if (self.segmentVC.currentDisplayItemIndex == 0) {
        [self setContentViewHeight:650 fullScreen:NO];
    }
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
//    __weak typeof(self) weakSelf = self;
//    [CNPayRequestManager paymentGetDepositNameWithType:YES CompleteHandler:^(id  _Nullable response, NSError * _Nullable error) {
//        if (result.status) {
//            [weakSelf configNameView:result.data];
//        }
//    }];

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
