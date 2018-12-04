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
@property (weak, nonatomic) IBOutlet UILabel *preSettingMessageLb;
@property (weak, nonatomic) IBOutlet UITextField *payTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UILabel *depositByLb;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *chargeTF;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;

@end

@implementation CNPayDepositStep3VC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 输入金额变化处理
    //    __weak typeof(self) weakSelf = self;
    //    self.amountTF.editingChanged = ^(NSString *text, BOOL isEmpty) {
    //        [weakSelf.recommendView cleanSelectedState];
    //    };
    
    // 金额提示语
    //    if (self.paymentModel.maxamount > self.paymentModel.minamount) {
    //        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%.0f，最多%.0f", self.paymentModel.minamount, self.paymentModel.maxamount];
    //    } else {
    //        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%.0f", self.paymentModel.minamount];
    //    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configUI];
    [self addBankView];
    [self setViewHeight:550 fullScreen:NO];
}

- (void)configUI {
    self.preSettingMessageLb.text = self.preSaveMsg;
    self.depositByLb.text = self.writeModel.depositBy;
}


- (IBAction)selectPayType:(id)sender {
    [self.view endEditing:YES];
    NSArray *payTypeArr = [self.paymentModel payTypeArray];
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:_payTypeTF.placeholder dataSource:payTypeArr defaultSelValue:_payTypeTF.text resultBlock:^(id selectValue) {
        weakSelf.payTypeTF.text = selectValue;
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
    if (_amountTF.text.length == 0) {
        [self showError:_amountTF.placeholder];
        return;
    }
    if (_chargeTF.text.length == 0) {
        [self showError:_chargeTF.placeholder];
        return;
    }
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    self.writeModel.depositType = self.payTypeTF.text;
    self.writeModel.provience = self.provinceTF.text;
    self.writeModel.city = self.cityTF.text;
    self.writeModel.date = [NSString stringWithFormat:@"%@:00", _dateTF.text];
    self.writeModel.amount = self.amountTF.text;
    self.writeModel.charge = self.chargeTF.text;
    self.writeModel.remarks = self.remarkTF.text;
    self.writeModel.payId = self.paymentModel.payid;
    /// 提交请求
    __weak typeof(self) weakSelf = self;
    [CNPayRequestManager paymentCreateManualWithWriteInfo:self.writeModel completeHandler:^(IVRequestResultModel *result, id response) {
        sender.selected = NO;
        if (result.status) {
            [weakSelf paySucessHandler:result.data];
        } else {
            // 后台返回类型不一，全部转成字符串
            [weakSelf showError:[NSString stringWithFormat:@"%@", result.message]];
        }
    }];
}

- (void)paySucessHandler:(NSDictionary *)dic {
    
    NSError *error;
    CNPayOrderModel *orderModel = [[CNPayOrderModel alloc] initWithDictionary:dic error:&error];
    if (error && !orderModel) {
        [self showError:@"操作失败！请联系客户，或者稍后重试!"];
        return;
    }
    
}
@end
