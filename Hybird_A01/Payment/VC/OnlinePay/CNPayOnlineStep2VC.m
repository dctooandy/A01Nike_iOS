//
//  CNPayOnlineStep2VC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/29.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayOnlineStep2VC.h"
#import "CNWKWebVC.h"

@interface CNPayOnlineStep2VC ()
@property (weak, nonatomic) IBOutlet CNPayLabel *payTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UIView *recordView;

@end

@implementation CNPayOnlineStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configUI];
}

- (void)configUI {
    self.payTypeLb.text = self.writeModel.depositType;
    self.amountLb.text = self.writeModel.orderModel.amount;
    [self setViewHeight:500 fullScreen:YES];
}

- (IBAction)sumitAction:(UIButton *)sender {
//    CNWKWebVC *payWebVC = [[CNWKWebVC alloc] initWithHtmlString:[CNPayRequestManager submitPayFormWithOrderModel:self.writeModel.orderModel]];
//    [self pushViewController:payWebVC];
    [self pushUIWebViewWithURLString:[CNPayRequestManager submitPayFormWithOrderModel:self.writeModel.orderModel] title:self.payTypeLb.text];
}

- (IBAction)tradingRecord:(id)sender {
    [self pushUIWebViewWithURLString:@"customer/reports.htm" title:nil];
}

@end
