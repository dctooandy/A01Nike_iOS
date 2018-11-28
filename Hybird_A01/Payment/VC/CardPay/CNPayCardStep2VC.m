//
//  CNPayCardStep2VC.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/28.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayCardStep2VC.h"

@interface CNPayCardStep2VC ()

@end

@implementation CNPayCardStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)configCardValue:(NSString *)value {
    //    CGFloat amount = [value floatValue];
    //    self.totalValueLb.text = [NSString stringWithFormat:@"%.2f 元", amount];
    //    CGFloat charge = amount * self.writeModel.cardModel.value / 100.0;
    //    self.chargeValueLb.text = [NSString stringWithFormat:@"-%.2f 元", charge];
    //    self.actualValueLb.text = [NSString stringWithFormat:@"%.2f 元", (amount - charge)];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self pushUIWebViewWithURLString:[CNPayRequestManager submitPayFormWithOrderModel:self.writeModel.orderModel] title:self.paymentModel.paymentTitle];
}
@end
