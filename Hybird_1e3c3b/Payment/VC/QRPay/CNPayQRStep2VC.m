//
//  CNPayQRStep2VC.m
//  Hybird_1e3c3b
//
//  Created by cean.q on 2018/11/27.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayQRStep2VC.h"
#import "CNUIWebVC.h"
#import "CNWKWebVC.h"

@interface CNPayQRStep2VC ()
@property (weak, nonatomic) IBOutlet UILabel *billNoLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@end

@implementation CNPayQRStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.writeModel.depositType;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:350 fullScreen:YES];
    [self configUI];
}

- (void)configUI {
//    CNPayOrderModel *order = self.writeModel.orderModel;
    CNPayOrderModelV2 *orderV2 = self.writeModel.orderModelV2;

    _amountLb.text = [NSString stringWithFormat:@"￥%@", orderV2.amount];
    _billNoLb.text = orderV2.billNo;
    _titleLb.text = [NSString stringWithFormat:@"%@确认支付订单", self.writeModel.depositType];
}

- (IBAction)clickBtn:(CNPaySubmitButton *)sender {
    [self showPayTipView];
//    CNUIWebVC *webVC = [[CNUIWebVC alloc] initWithOrder:self.writeModel.orderModel title:self.writeModel.depositType];
    CNUIWebVC *webVC = [[CNUIWebVC alloc] initWithV2Order:self.writeModel.orderModelV2 title:self.writeModel.depositType];
    [self pushViewController:webVC];
}



@end
