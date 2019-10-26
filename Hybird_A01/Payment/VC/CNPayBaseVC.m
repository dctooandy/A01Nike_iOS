//
//  CNPayBaseVC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayBaseVC.h"
#import "CNPayVC.h"
#import "CNWKWebVC.h"
#import "CNUIWebVC.h"
#import <Photos/Photos.h>

#import "CNPayTipView.h"
#import "CNPayOrderModel.h"



@interface CNPayBaseVC ()
@property (nonatomic, strong) CNPayTipView *tipView;
@property (nonatomic, weak) CNPayVC *payVC;
@end

@implementation CNPayBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBlackBackgroundColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (NSString *)preSaveMsg {
#warning 预留信息
    return @"";//[IVNetwork userInfo].verify_code;
}

- (void)showError:(NSString *)error {
    dispatch_main_async_safe(^{
        [MBProgressHUD showError:error toView:self.view];
    });
}

- (void)showSuccess:(NSString *)success {
    dispatch_main_async_safe(^{
        [MBProgressHUD showSuccess:success toView:self.view];
    });
}

- (void)showLoading {
    dispatch_main_async_safe(^{
        [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    });
}
- (void)hideLoading {
    dispatch_main_async_safe(^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    });
}

- (void)goToStep:(NSInteger)index {
    AMSegmentViewController *segmentVC = (AMSegmentViewController *)self.parentViewController;
    [segmentVC transitionItemsToIndex:index complteBlock:nil];
}

- (CNPayWriteModel *)writeModel {
    if (!_writeModel) {
        AMSegmentViewController *segmentVC = (AMSegmentViewController *)self.parentViewController;
        _writeModel = segmentVC.writeModel;
    }
    return _writeModel;
}

- (NSArray *)recommendAmountAccordingMinAmount:(double)minAmount max:(double)maxAmount {
    double max = maxAmount;
    // 最大有可能为空
    if (maxAmount < minAmount) {
        max = MAXFLOAT;
    }
    NSArray *amountArr = [self.paymentModel prePayAmountArray];
    double firstItem = [amountArr.firstObject doubleValue];
    double lastItem = [amountArr.lastObject doubleValue];
    
    // 无交集, 取俩区间最大值中的最小值
    if (lastItem < minAmount || firstItem > max) {
        return @[[NSString stringWithFormat:@"%lf", MIN(lastItem, max)]];
    }
    
    // 有交集, 取区间值
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF > %@ AND SELF < %@", @(minAmount), @(max)];
    NSMutableArray *filtArr = [[amountArr filteredArrayUsingPredicate:pre] mutableCopy];
    
    // 需要把限值考虑进去
    if (minAmount >= firstItem) {
        [filtArr insertObject:@(minAmount) atIndex:0];
    }
    if (max <= lastItem) {
        [filtArr addObject:@(max)];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSNumber *number in filtArr) {
        [array addObject:number.stringValue];
    }
    return array;
}

/**
 充值成功回调处理
 */
- (void)paySucessHandler:(NSDictionary *)model repay:(dispatch_block_t)repayBlock {
#warning 接口调试
    // 数据容灾
//    if (![model.data isKindOfClass:[NSDictionary class]]) {
//        // 后台返回类型不一，全部转成字符串
//        [self showError:[NSString stringWithFormat:@"%@", model.message]];
//        return;
//    }
//
//    NSError *error;
//    CNPayOrderModel *orderModel = [[CNPayOrderModel alloc] initWithDictionary:model.data error:&error];
//    if (error && !orderModel) {
//        [self showError:@"操作失败！请联系客户，或者稍后重试!"];
//        return;
//    }
//    [self showPayTipView];
//    CNUIWebVC *webVC = [[CNUIWebVC alloc] initWithOrder:orderModel title:self.paymentModel.paymentTitle];
//    [self pushViewController:webVC];
}

- (void)pushUIWebViewWithURLString:(NSString *)url title:(NSString *)title {
    CNUIWebVC *payWebVC = [[CNUIWebVC alloc] initWithUrl:url title:title];
    [self pushViewController:payWebVC];
}

/// 栈顶推出控制器
- (void)pushViewController:(UIViewController *)vc {
    [self.payVC.navigationController pushViewController:vc animated:YES];
}

- (void)popToRootViewController {
    [self.payVC.navigationController popToRootViewControllerAnimated:YES];
}

/// 查找顶部视图控制器
- (UINavigationController *)topNavigationController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topNavigationController:[(UITabBarController *)vc selectedViewController]];
    }
    return nil;
}

- (void)setViewHeight:(CGFloat)height fullScreen:(BOOL)full {
    [self.payVC setContentViewHeight:height fullScreen:full];
}

/// 获取app支付方式字符串
- (NSString *)getPaytypeString {
    
    NSString *paytypeString;
    switch (self.paymentModel.paymentType) {
            
        case CNPaymentUnionApp:
            paytypeString = @"19";
            break;
        case CNPaymentOnline:
            paytypeString = @"1";
            break;
        case CNPaymentWechatApp:
            paytypeString = @"8";
            break;
        case CNPaymentWechatQR:
            paytypeString = @"6";
            break;
        case CNPaymentAliApp:
            paytypeString = @"9";
            break;
        case CNPaymentAliQR:
            paytypeString = @"5";
            break;
        case CNPaymentQQApp:
            paytypeString = @"11";
            break;
        case CNPaymentQQQR:
            paytypeString = @"7";
            break;
        case CNPaymentUnionQR:
            paytypeString = @"15";
            break;
        case CNPaymentJDApp:
            paytypeString = @"17";
            break;
        case CNPaymentJDQR:
            paytypeString = @"16";
            break;
        case CNPaymentBTC:
            paytypeString = @"20";
            break;
        case CNPaymentCard:
            paytypeString = @"2";
            break;
        case CNPaymentWechatBarCode:
            paytypeString = @"23";
            break;
        case CNPaymentYSFQR:
            paytypeString = @"27";
            break;
        case CNPaymentCoin:
            paytypeString = @"41";
            break;
        case CNPaymentDeposit:
        case CNPaymentBQFast:
        case CNPaymentBQWechat:
        case CNPaymentBQAli:
        case CNPaymentBS:
            paytypeString = @"";
            break;
    }
    return paytypeString;
}

/// 截图
- (UIImage *)creatViewImage:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)saveToLibraryWithImage:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                        [weakSelf showSuccess:@"图片已存至相册"];
                    } error:nil];
                }
                    break;
                case PHAuthorizationStatusDenied:
                    [self showError:@"请到设置开启访问相册权限"];
                    break;
                case PHAuthorizationStatusRestricted:
                    [self showError:@"相册访问受限"];
                    break;
                default:
                    break;
            }
        });
    }];
}

- (void)addBankView {
    [self.payVC addBankView];
}

#pragma mark - 支付后提示页面

-(CNPayVC *)payVC {
    if (!_payVC) {
        UINavigationController *navi = [self topNavigationController:[[UIApplication sharedApplication].keyWindow rootViewController]];
        for (UIViewController *vc in navi.viewControllers) {
            if ([vc isKindOfClass:[CNPayVC class]]) {
                _payVC = (CNPayVC *)vc;
                break;
            }
        }
    }
    return _payVC;
}

- (void)showPayTipView {
    weakSelf(weakSelf);
    CNPayTipView *tipView = [CNPayTipView tipView];
    tipView.frame = self.payVC.view.bounds;
    [self.payVC.view addSubview:tipView];
    tipView.btnAction = ^{
        [weakSelf.payVC.navigationController popToRootViewControllerAnimated:YES];
    };
}



@end
