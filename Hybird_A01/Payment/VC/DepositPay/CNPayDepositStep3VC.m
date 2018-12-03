//
//  CNPayDepositStep3VC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/1.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayDepositStep3VC.h"
#import "AMSegmentViewController.h"
#import <Photos/Photos.h>

@interface CNPayDepositStep3VC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIImageView *bankBGIV;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLb;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLb;
@property (weak, nonatomic) IBOutlet UILabel *bankAccountLb;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLb;
@property (weak, nonatomic) IBOutlet UILabel *bankAddressLb;

@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UILabel *depositByLb;
@property (weak, nonatomic) IBOutlet UITextField *payTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *TVPlaceholderLabel;

@end

@implementation CNPayDepositStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.remarkTextView.contentInset = UIEdgeInsetsZero;
    UIColor *color = (UIColor *)[self.provinceTF valueForKeyPath:@"_placeholderLabel.textColor"];
    self.TVPlaceholderLabel.textColor = color;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configUI];
    [self addBankView];
    [self setViewHeight:550 fullScreen:NO];
}

- (void)configUI {
    CNPayBankCardModel *bankModel = self.writeModel.chooseBank;
    [self.bankLogoIV sd_setImageWithURL:[NSURL URLWithString:bankModel.banklogo.cn_appendCDN]];
    [self.bankBGIV sd_setImageWithURL:[NSURL URLWithString:bankModel.bankimage.cn_appendCDN] placeholderImage:[UIImage imageNamed:@"pay_bankBG"]];
    self.bankNameLb.text = bankModel.bank_name;
    self.bankAccountLb.text = bankModel.bank_account_no;
    self.accountNameLb.text = bankModel.bank_show;
    self.bankAddressLb.text = [NSString stringWithFormat:@"%@ %@ %@", bankModel.province, bankModel.bank_city, bankModel.branch_name];
    self.amountLb.text = self.writeModel.amount;
    self.depositByLb.text = self.writeModel.depositBy;
    NSString *dateString = [NSDate br_getDateString:[NSDate dateWithTimeIntervalSinceNow:900] format:@"yyyy年MM月dd日 hh:mm"];
    self.deadlineLb.text = [NSString stringWithFormat:@"有效期限至：\n%@", dateString];
}

- (IBAction)saveBankImage:(UIButton *)sender {
    [self saveToLibraryWithImage:[self creatViewImage:self.bankView]];
}

- (IBAction)selectPayType:(id)sender {
    [self.view endEditing:YES];
    NSArray *payTypeArr = [self.paymentModel payTypeArray];
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:_payTypeTF.placeholder dataSource:payTypeArr defaultSelValue:nil resultBlock:^(id selectValue) {
//        weakSelf.payTypeTF.text = payTypeArr[index];
    }];
}

// 选择省市
- (IBAction)selectProvince:(id)sender {
    [self.view endEditing:YES];
    weakSelf(weakSelf);
    // 默认选择的省市
    NSArray *defaultSelect = @[_provinceTF.text, _cityTF.text];
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:nil defaultSelected:defaultSelect isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        weakSelf.provinceTF.text = province.name;
        weakSelf.cityTF.text = city.name;
    } cancelBlock:^{
        
    }];
}

// 选择日期
- (IBAction)selectDate:(id)sender {
    [self.view endEditing:YES];
    
    weakSelf(weakSelf);
    NSDate *minDate = [NSDate br_setYear:2018 month:01 day:01 hour:0 minute:0];
    NSDate *maxDate = [NSDate br_setYear:2030 month:12 day:31 hour:23 minute:59];
    
    [BRDatePickerView showDatePickerWithTitle:_dateTF.placeholder dateType:BRDatePickerModeYMDHM defaultSelValue:nil minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
        weakSelf.dateTF.text = selectValue;
    } cancelBlock:^{
        
    }];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_payTypeTF.text.length == 0) {
        [self showError:_payTypeTF.placeholder];
        return;
    }
    if (_provinceTF.text.length == 0) {
        [self showError:_provinceTF.placeholder];
        return;
    }
    if (_cityTF.text.length == 0) {
        [self showError:_cityTF.placeholder];
        return;
    }
    if (_dateTF.text.length == 0) {
        [self showError:_dateTF.placeholder];
        return;
    }
    
    self.writeModel.depositType = self.payTypeTF.text;
    self.writeModel.provience = self.provinceTF.text;
    self.writeModel.city = self.cityTF.text;
    self.writeModel.date = [NSString stringWithFormat:@"%@:00", _dateTF.text];
    self.writeModel.remarks = self.remarkTextView.text;
    
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    /// 提交请求
    __weak typeof(self) weakSelf = self;
    [self showLoading];
    [CNPayRequestManager paymentCreateManualWithWriteInfo:self.writeModel completeHandler:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        sender.selected = NO;
        [weakSelf paySucessHandler:result repay:nil];
    }];
}

#pragma mark - UITextviewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.markedTextRange == nil) {
        if (textView.text.length == 0) {
            self.TVPlaceholderLabel.hidden = NO;
        }
    }
    if (textView.text.length > 30) { //限制30个字符
        textView.text = [textView.text substringToIndex:30];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *futureText = [NSMutableString stringWithString:textView.text];
    [futureText insertString:text atIndex:range.location];
    self.TVPlaceholderLabel.hidden = !(futureText.length == 0);
    return YES;
}

- (IBAction)tradingRecord:(id)sender {
    [self pushUIWebViewWithURLString:@"customer/reports.htm" title:nil];
}
@end
