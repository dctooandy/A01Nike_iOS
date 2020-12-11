//
//  CNPayDepositStep2VC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/1.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayDepositStep2VC.h"
#import "CNPayDepositTipView.h"

@interface CNPayDepositStep2VC ()
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;

@property (weak, nonatomic) IBOutlet UIImageView *bankBGIV;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLb;
@property (weak, nonatomic) IBOutlet UILabel *bankAccountLb;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLb;
@property (weak, nonatomic) IBOutlet UILabel *bankAddressLb;
@end

@implementation CNPayDepositStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:550 fullScreen:NO];
    [self configUI];
}

- (void)configUI {
    CNPayBankCardModel *bankModel = self.writeModel.chooseBank;
    [self.bankLogoIV sd_setImageWithURL:[NSURL URLWithString:bankModel.bankIcon.cn_appendCDN]];
    [self.bankBGIV sd_setImageWithURL:[NSURL URLWithString:bankModel.bankIcon.cn_appendCDN] placeholderImage:[UIImage imageNamed:@"pay_bankBG"]];
    self.bankNameLb.text = bankModel.bankName;
    self.bankAccountLb.text = bankModel.accountNo;
    self.accountNameLb.text = bankModel.accountName;
    self.bankAddressLb.text = [NSString stringWithFormat:@"%@ %@ %@", bankModel.province, bankModel.city, bankModel.bankBranchName];
    self.bankNameTF.text = bankModel.bankName;
}

// 选择银行
- (IBAction)selectBank:(UIButton *)sender {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *bankNames = [NSMutableArray arrayWithCapacity:self.writeModel.bankList.count];
    for (CNPayBankCardModel *model in self.writeModel.bankList) {
        [bankNames addObject:model.bankName];
    }
    [BRStringPickerView showStringPickerWithTitle:_bankNameTF.placeholder dataSource:bankNames defaultSelValue:_bankNameTF.text resultBlock:^(id selectValue, NSInteger index) {
        if ([weakSelf.bankNameTF.text isEqualToString:selectValue]) {
            return;
        }
        weakSelf.bankNameTF.text = selectValue;
        weakSelf.writeModel.chooseBank = weakSelf.writeModel.bankList[index];
        [weakSelf configUI];
    }];
}

- (IBAction)copyAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = _bankAccountLb.text;
    [self showSuccess:@"已复制到剪切板"];
}

- (IBAction)sumbitAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    __weak typeof(self) weakSelf = self;
    [CNPayDepositTipView showTipViewFinish:^{
        [weakSelf goToStep:2];
    }];
}

@end
