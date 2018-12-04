//
//  CNPayDepositStep2VC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/1.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayDepositStep2VC.h"

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
    [self.bankLogoIV sd_setImageWithURL:[NSURL URLWithString:bankModel.banklogo.cn_appendCDN]];
    [self.bankBGIV sd_setImageWithURL:[NSURL URLWithString:bankModel.bankimage.cn_appendCDN] placeholderImage:[UIImage imageNamed:@"pay_bankBG"]];
    self.bankNameLb.text = bankModel.bank_name;
    self.bankAccountLb.text = bankModel.bank_account_no;
    self.accountNameLb.text = bankModel.bank_show;
    self.bankAddressLb.text = [NSString stringWithFormat:@"%@ %@ %@", bankModel.province, bankModel.bank_city, bankModel.branch_name];
    self.bankNameTF.text = bankModel.bank_name;
}

// 选择银行
- (IBAction)selectBank:(UIButton *)sender {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *bankNames = [NSMutableArray arrayWithCapacity:self.writeModel.bankList.count];
    for (CNPayBankCardModel *model in self.writeModel.bankList) {
        [bankNames addObject:model.bank_name];
    }
    [BRStringPickerView showStringPickerWithTitle:_bankNameTF.placeholder dataSource:bankNames defaultSelValue:_bankNameTF.text resultBlock:^(NSString * selectValue) {
        if ([weakSelf.bankNameTF.text isEqualToString:selectValue]) {
            return;
        }
        weakSelf.bankNameTF.text = selectValue;
        NSInteger index = [bankNames indexOfObject:selectValue];
        weakSelf.writeModel.chooseBank = weakSelf.writeModel.bankList[index];
        [weakSelf configUI];
    }];
}

- (IBAction)copyAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = _bankAccountLb.text;
    [self showSuccess:@"已复制到剪切板"];
}

- (IBAction)sumbitAction:(UIButton *)sender {
    [self goToStep:2];
}

@end
