//
//  CNPayCardStep3VC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/24.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayCardStep3VC.h"

@interface CNPayCardStep3VC ()
@property (weak, nonatomic) IBOutlet UILabel *totalValueLb;
@property (weak, nonatomic) IBOutlet UILabel *chargeValueLb;
@property (weak, nonatomic) IBOutlet UILabel *actualValueLb;
@property (weak, nonatomic) IBOutlet UILabel *billLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (nonatomic, strong) CNPayOrderModel *orderModel;
@end

@implementation CNPayCardStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    self.orderModel = self.writeModel.orderModel;
    CNPayCardModel *model = self.writeModel.cardModel;
    self.totalValueLb.text = model.totalValue;
    self.chargeValueLb.text = model.chargeValue;
    self.actualValueLb.text = model.actualValue;
    self.amountLb.text = self.orderModel.amount;
    self.billLb.text = self.orderModel.billno;
}

- (IBAction)submitAction:(UIButton *)sender {
     [self pushUIWebViewWithURLString:[CNPayRequestManager submitPayFormWithOrderModel:self.writeModel.orderModel] title:self.paymentModel.paymentTitle];
}

@end
