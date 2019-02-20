//
//  CNPayDepositStep1VC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/1.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayDepositStep1VC.h"


@interface CNPayDepositStep1VC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet CNPayAmountRecommendView *nameView;
@property (weak, nonatomic) IBOutlet UIView *nameAreaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameAreaViewHeight;
@end

@implementation CNPayDepositStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configRecommendView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:350 fullScreen:NO];
}

/// 推荐姓名
- (void)configRecommendView {
    if (self.paymentModel.depositor.length == 0) {
        _nameAreaView.hidden = YES;
        _nameAreaViewHeight.constant = 0;
        return;
    }
    NSArray *array = [self.paymentModel.depositor componentsSeparatedByString:@";"];
    if (array.count == 0) {
        _nameAreaView.hidden = YES;
        _nameAreaViewHeight.constant = 0;
        return;
    }
    _nameTF.text = array.firstObject;
    _nameView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    _nameView.clickHandler = ^(NSString *value, NSInteger index) {
        [weakSelf.view endEditing:YES];
        weakSelf.nameTF.text = value;
    };
}

- (IBAction)sumbitAction:(UIButton *)sender {
    if (self.nameTF.text.length == 0) {
        [self showError:@"请输入存款人姓名"];
        return;
    }
    [self depositGetBank:sender];
}

- (void)depositGetBank:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    __weak typeof(self) weakSelf = self;
    __weak typeof(sender) weakSender = sender;
    // 获取银行卡列表
    NSInteger bqPaymentType = 0;
    if (self.paymentModel.paymentType == CNPaymentBQAli) {
        bqPaymentType = 2;
    } else if (self.paymentModel.paymentType == CNPaymentBQWechat) {
        bqPaymentType = 1;
    }
    [CNPayRequestManager paymentGetBankListWithType:YES depositor:self.nameTF.text referenceId:nil BQPayType:bqPaymentType completeHandler:^(IVRequestResultModel *result, id response) {
        weakSender.selected = NO;
        if (!result.status) {
            [weakSelf showError:result.message];
            return;
        }
        /// 数据解析
        NSArray *array = result.data;
        NSArray *bankList = [CNPayBankCardModel arrayOfModelsFromDictionaries:array error:nil];
        if (bankList.count == 0) {
            [self showError:result.message];
            return;
        }
        weakSelf.writeModel.depositBy = weakSelf.nameTF.text;
        weakSelf.writeModel.bankList = bankList;
        weakSelf.writeModel.chooseBank = bankList.firstObject;
        [weakSelf goToStep:1];
    }];
}

@end
