//
//  CNPayQRStep2VC.m
//  Hybird_A01
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:350 fullScreen:YES];
    [self configUI];
}

- (void)configUI {
    CNPayOrderModel *order = self.writeModel.orderModel;
    _amountLb.text = [NSString stringWithFormat:@"￥%@", order.amount];
    _billNoLb.text = order.billNo;
    _titleLb.text = [NSString stringWithFormat:@"%@确认支付订单", self.writeModel.depositType];
}

- (IBAction)clickBtn:(CNPaySubmitButton *)sender {
    [self showPayTipView];
    CNUIWebVC *webVC = [[CNUIWebVC alloc] initWithOrder:self.writeModel.orderModel title:self.writeModel.depositType];
    [self pushViewController:webVC];
}



@end
