//
//  CNPayDepositSuccessVC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/5.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayDepositSuccessVC.h"
#import "CNPaySubmitButton.h"
#import "CNUIWebVC.h"
#import "CNPayConstant.h"

@interface CNPayDepositSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (nonatomic, copy) NSString *amount;
@end

@implementation CNPayDepositSuccessVC

- (instancetype)initWithAmount:(NSString *)amount {
    if (self = [super init]) {
        self.amount = amount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手工存款";
    self.view.backgroundColor = COLOR_HEX(0x333542);
    self.amountLb.text = [NSString stringWithFormat:@"存款金额：%@元", self.amount];
}

- (IBAction)payList:(id)sender {
    WebConfigModel *webConfig = [[WebConfigModel alloc] init];
    webConfig.url = @"customer/log.htm";
    webConfig.newView = YES;
    HAWebViewController *webVC = [[HAWebViewController alloc] init];
    webVC.webConfigModel = webConfig;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)gameHoll:(id)sender {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
