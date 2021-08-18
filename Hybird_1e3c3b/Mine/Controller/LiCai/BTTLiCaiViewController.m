//
//  BTTLiCaiViewController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/26/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiViewController.h"
#import "BTTLiCaiBannerCell.h"
#import "BTTHomePageSeparateCell.h"
#import "BTTLiCaiTotalAmountCell.h"
#import "BTTLiCaiBtnCell.h"
#import "BTTLiCaiTransRecordController.h"
#import "BTTLiCaiViewController+LoadData.h"
#import "BTTPromotionDetailController.h"
#import <IQKeyboardManager.h>

@interface BTTLiCaiViewController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTLiCaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活期理财钱包";
    self.interestRate = @"加载中";
    self.walletAmount = @"加载中";
    self.earn = @"加载中";
    self.accountBalance = @"加载中";
    [self setUpNav];
    [self loadYebConfig];
    [self loadLocalAmount];
    [self loadInterestSum];
    [self setupElements];
}

-(void)keyboardWillHideNotification:(NSNotification*)notify {
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.inDetailPopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    }];
}

-(void)keyboardWillShowNotification:(NSNotification*)notify {
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY = 320-self.inDetailPopView.textField.frame.origin.y-self.inDetailPopView.textField.frame.size.height-25-keyboardFrame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.inDetailPopView.frame = CGRectMake(0, transformY, SCREEN_WIDTH, self.view.frame.size.height);
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)setUpNav {
    UIButton * rightBtn = [[UIButton alloc] init];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.adjustsImageWhenHighlighted = false;
    [rightBtn setTitle:@" 咨询客服" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"homepage_service"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(kefuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

-(void)kefuBtnAction {
    [LiveChat startKeFu:self];
//    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
//        if (errCode != CSServiceCode_Request_Suc) {
//            [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
//        } else {
//
//        }
//    }];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLiCaiBannerCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLiCaiBannerCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLiCaiTotalAmountCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLiCaiTotalAmountCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLiCaiBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLiCaiBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf);
    if (indexPath.row == 0) {
        BTTLiCaiBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLiCaiBannerCell" forIndexPath:indexPath];
        cell.bannerClickBlock = ^{
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.title = @"活期理财30%";
            vc.webConfigModel.url = @"/activity_pages/interest30";
            vc.webConfigModel.newView = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    } else if (indexPath.row == 1) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 2) {
        BTTLiCaiTotalAmountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLiCaiTotalAmountCell" forIndexPath:indexPath];
        if ([self.walletAmount isEqualToString:@"加载中"]) {
            cell.walletAmount = self.walletAmount;
        } else {
            cell.walletAmount = [PublicMethod transferNumToThousandFormat:[self.walletAmount doubleValue]];
        }
        if ([self.earn isEqualToString:@"加载中"]) {
            cell.earn = self.earn;
        } else {
            cell.earn = [PublicMethod transferNumToThousandFormat:[self.earn doubleValue]];
        }
        
        if ([self.interestRate isEqualToString:@"加载中"]) {
            cell.interestRate = self.interestRate;
        } else {
            cell.interestRate = [NSString stringWithFormat:@"%@%%", self.interestRate];
        }
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            BTTLiCaiTransRecordController * vc = [[BTTLiCaiTransRecordController alloc] init];
            vc.transferType = 2;
            vc.lastDays = 1;
            [weakSelf.navigationController pushViewController:vc animated:true];
        };
        return cell;
    } else {
        BTTLiCaiBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLiCaiBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            if (button.tag == 0) {//out
                [self loadTransferInRecords:^(NSMutableArray * _Nonnull modelArr) {
                    if (modelArr.count >0) {
                        [self loadServerTime:^(NSString * _Nonnull timeStr) {
                            self.OutDetailPopView = [BTTLiCaiOutDetailPopView viewFromXib];
                            self.OutDetailPopView.serverTimeStr = timeStr;
                            [self.view addSubview:self.OutDetailPopView];
                            self.OutDetailPopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
                            self.OutDetailPopView.modelArr = modelArr;
                            weakSelf(weakSelf)
                            self.OutDetailPopView.closeBtnClickBlock = ^(UIButton * _Nonnull button) {
                                [weakSelf.OutDetailPopView removeFromSuperview];
                            };
                            
                            self.OutDetailPopView.transferOutBtnClickBlock = ^(UIButton * _Nonnull button) {
                                [weakSelf transferOut:^{
                                    [weakSelf.OutDetailPopView removeFromSuperview];
                                    [MBProgressHUD showSuccess:@"转出成功" toView:nil];
                                }];
                            };
                        }];
                        
                    } else {
                        [MBProgressHUD showError:@"当前无计息订单" toView:nil];
                    }
                }];
                
            } else if (button.tag == 1) {//in
                
                self.inDetailPopView = [BTTLiCaiInDetailPopView viewFromXib];
                [self.view addSubview:self.inDetailPopView];
                self.inDetailPopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
                self.inDetailPopView.accountBalance = self.accountBalance;
                weakSelf(weakSelf)
                self.inDetailPopView.closeBtnClickBlock = ^(UIButton * _Nonnull button) {
                    [weakSelf.inDetailPopView removeFromSuperview];
                };
                
                self.inDetailPopView.transferBtnClickBlock = ^(UIButton * _Nonnull button, NSString * _Nonnull amount) {
                    [weakSelf transferIn:amount completeBlock:^{
                        [weakSelf.inDetailPopView removeFromSuperview];
                        [MBProgressHUD showSuccess:@"转入成功" toView:nil];
                    }];
                };
                
            }
        };
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(BTTCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    BTTCollectionViewFlowlayout *elementsFlowLayout = [[BTTCollectionViewFlowlayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSInteger total = 4;
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth) + 2 * 10)]];
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 10)]];
        } else if (i == 2) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 245)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 85)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
