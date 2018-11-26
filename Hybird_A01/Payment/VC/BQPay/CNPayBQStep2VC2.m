//
//  CNPayBQStep2VC2.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/23.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayBQStep2VC2.h"

@interface CNPayBQStep2VC2 ()
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation CNPayBQStep2VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDifferentUI];
    [self setViewHeight:500 fullScreen:YES];
}

- (void)configDifferentUI {
    if (self.paymentModel.paymentType == CNPaymentBQWechat) {
        self.bottomView.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.amountLb.text = self.writeModel.chooseBank.amount;
}

- (IBAction)submitAction:(UIButton *)sender {
    [self goToStep:2];
}

- (IBAction)tradingRecord:(id)sender {
    [self pushUIWebViewWithURLString:@"customer/reports.htm" title:nil];
}
@end
