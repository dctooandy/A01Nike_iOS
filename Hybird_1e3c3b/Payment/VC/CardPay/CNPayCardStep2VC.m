//
//  CNPayCardStep2VC.m
//  Hybird_1e3c3b
//
//  Created by cean.q on 2018/11/28.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayCardStep2VC.h"

@interface CNPayCardStep2VC ()
@property (weak, nonatomic) IBOutlet UILabel *billNoLb;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *chargeLb;
@property (weak, nonatomic) IBOutlet UILabel *valueLb;

@end

@implementation CNPayCardStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:350 fullScreen:YES];
    [self configCardValue];
}

- (void)configCardValue {
    CNPayOrderModel *order = self.writeModel.orderModel;
    _billNoLb.text = order.billNo;
    _cardTypeLb.text = self.writeModel.cardModel.name;
    CGFloat amount = [order.amount floatValue];
    CGFloat charge = amount * self.writeModel.cardModel.value / 100.0;
    _chargeLb.text = [NSString stringWithFormat:@"%.2f元", charge];
    _valueLb.text = [NSString stringWithFormat:@"￥ %@元", order.amount];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self showPayTipView];
//    [self pushUIWebViewWithURLString:[CNPayRequestManager submitPayFormWithOrderModel:self.writeModel.orderModel] title:self.paymentModel.paymentTitle];
}
@end
