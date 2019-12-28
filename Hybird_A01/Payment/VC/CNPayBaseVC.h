//
//  CNPayBaseVC.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNPaymentModel.h"
#import "CNPayRequestManager.h"
#import "NSString+CNPayment.h"

#import "CNPayAmountTF.h"
#import "CNPayNameTF.h"
#import "CNPayAmountRecommendView.h"
#import "CNPaySubmitButton.h"
#import "CNPayLabel.h"

#import "AMSegmentViewController.h"
#import "CNPayConstant.h"
#import "BTTBaseViewController.h"


@interface CNPayBaseVC : BTTBaseViewController
// 内部切换数据
@property (nonatomic, copy) NSArray<CNPaymentModel *> *payments;

@property (nonatomic, strong) CNPaymentModel *paymentModel;
/// 用户填写信息
@property (nonatomic, weak) CNPayWriteModel *writeModel;
/// 预留信息
@property (nonatomic, readonly) NSString *preSaveMsg;

- (void)showError:(NSString *)error;
- (void)showSuccess:(NSString *)success;
- (void)showLoading;
- (void)hideLoading;

/// 获取app支付方式字符串
- (NSString *)getPaytypeString;


/**
 到指定支付步骤

 @param index 步骤数，0，1，2...
 */
- (void)goToStep:(NSInteger)index;

/**
 根据金额限制获取用户推荐金额
 
 @param minAmount 最小限额
 @param maxAmount 最大限额
 @return 返回更正后的推荐金额数组
 */
- (NSArray *)recommendAmountAccordingMinAmount:(double)minAmount max:(double)maxAmount;


/**
 申请支付成功后展示
 
 @param model 申请成功支付模型
 @param repayBlock 重新支付的业务处理
 */
- (void)paySucessHandler:(IVRequestResultModel *)model repay:(dispatch_block_t)repayBlock;

/// 申请支付成功后USDT
/// @param model 模型
/// @param repayBlock 重新支付的业务类型
- (void)paySucessUSDTHandler:(IVRequestResultModel *)model repay:(dispatch_block_t)repayBlock;

/**
 顶部导航push新的控制器
 
 @param vc  push 的VC
 */
- (void)pushViewController:(UIViewController *)vc;
- (void)popToRootViewController;

/**
 设置当前内容高度

 @param height  设置当前内容的高度
 @param full    是否充满全屏
 */
- (void)setViewHeight:(CGFloat)height fullScreen:(BOOL)full;

/**
 UIWebView加载页面

 @param url     加载的url
 @param title   webView控制器的标题
 */
- (void)pushUIWebViewWithURLString:(NSString *)url title:(NSString *)title;

/**
 截图

 @param view 要截图的view
 @return 图片
 */
- (UIImage *)creatViewImage:(UIView *)view;

/**
 保存图片到相册

 @param image 存入的图片
 */
- (void)saveToLibraryWithImage:(UIImage *)image;

- (void)addBankView;
- (void)showPayTipView;
@end
