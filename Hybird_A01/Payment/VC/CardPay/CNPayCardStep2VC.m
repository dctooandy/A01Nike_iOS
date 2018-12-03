//
//  CNPayCardStep2VC.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/28.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayCardStep2VC.h"

@interface CNPayCardStep2VC ()
@property (weak, nonatomic) IBOutlet UILabel *billNoLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeLb;
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
    CNPayCardModel *cardModel = self.writeModel.cardModel;
//    _billNoLb.text = cardModel.
    CGFloat amount = [cardModel.amount floatValue];
    CGFloat charge = amount * cardModel.value / 100.0;
    _chargeLb.text = [NSString stringWithFormat:@"%.2f元", charge];
    _valueLb.text = [NSString stringWithFormat:@"￥ %.2f元", (amount - charge)];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self pushUIWebViewWithURLString:[CNPayRequestManager submitPayFormWithOrderModel:self.writeModel.orderModel] title:self.paymentModel.paymentTitle];
}
@end
