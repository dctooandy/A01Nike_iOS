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
@property (weak, nonatomic) IBOutlet CNPaySubmitButton *gameHollBtn;
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
    self.amountLb.attributedText = [self addFollowString:self.amount];
    [self.gameHollBtn setBackgroundColor:COLOR_HEX(0xE84747)];
}

- (IBAction)payList:(id)sender {
    WebConfigModel *webConfig = [[WebConfigModel alloc] init];
    webConfig.url = @"customer/log.htm";
    webConfig.newView = YES;
//    WebController *webVC = [[WebController alloc] initWithWebConfigModel:webConfig];
//    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)gameHoll:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSAttributedString *)addFollowString:(NSString *)string {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"存款金额：%@ 元！", string]];
    NSRange range = NSMakeRange(5, string.length);
    [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGBA(234,115,11,1) range:range];
    return attrStr;
}
@end
