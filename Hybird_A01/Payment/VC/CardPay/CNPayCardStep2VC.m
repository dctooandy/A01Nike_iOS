//
//  CNPayCardStep2VC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/24.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayCardStep2VC.h"

@interface CNPayCardStep2VC ()
@property (weak, nonatomic) IBOutlet UIImageView *cardLogoIV;

@property (weak, nonatomic) IBOutlet UITextField *cardValueTF;

@property (weak, nonatomic) IBOutlet UILabel *totalValueLb;
@property (weak, nonatomic) IBOutlet UILabel *chargeValueLb;
@property (weak, nonatomic) IBOutlet UILabel *actualValueLb;

@property (weak, nonatomic) IBOutlet UITextField *cardNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *cardPwdTF;
@property (nonatomic, copy) NSArray *cardValues;
@end

@implementation CNPayCardStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:650 fullScreen:YES];
    [self updateUI];
}

- (void)updateUI {
    CNPayCardModel *model = self.writeModel.cardModel;
    [self.cardLogoIV sd_setImageWithURL:[NSURL URLWithString:model.logo.cn_appendCDN]];
    self.cardValues = model.cardValues;
    [self configCardValue:nil];
}

- (IBAction)backToLastStep:(id)sender {
    [self goToStep:0];
}

/// 选择点卡面额
- (IBAction)selectCardValue:(UIButton *)sender {
    [self.view endEditing:YES];
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:_cardValueTF.placeholder dataSource:_cardValues defaultSelValue:_cardValueTF.text resultBlock:^(id selectValue) {
//        [weakSelf configCardValue:weakSelf.cardValues[index]];
    }];
}

- (void)configCardValue:(NSString *)value {
    self.cardValueTF.text = value;
    CGFloat amount = [value floatValue];
    self.totalValueLb.text = [NSString stringWithFormat:@"%.2f 元", amount];
    CGFloat charge = amount * self.writeModel.cardModel.value / 100.0;
    self.chargeValueLb.text = [NSString stringWithFormat:@"-%.2f 元", charge];
    self.actualValueLb.text = [NSString stringWithFormat:@"%.2f 元", (amount - charge)];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.cardValueTF.text.length == 0) {
        [self showError:self.cardValueTF.placeholder];
        return;
    }
    
    if (self.cardNumberTF.text.length == 0) {
        [self showError:self.cardNumberTF.placeholder];
        return;
    }
    
    if (self.cardPwdTF.text.length == 0) {
        [self showError:self.cardPwdTF.placeholder];
        return;
    }
    
    [self submitCardPay:sender];
}

- (void)submitCardPay:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    /// 提交
    __weak typeof(self) weakSelf =  self;
    [CNPayRequestManager paymentCardPay:[self getCardModel] completeHandler:^(IVRequestResultModel *result, id response) {
        sender.selected = NO;
        if (result.status) {
            CNPayOrderModel *model = [[CNPayOrderModel alloc] initWithDictionary:result.data error:nil];
            weakSelf.writeModel.orderModel = model;
            [weakSelf goToStep:2];
        } else {
            [self showError:result.message];
        }
    }];
}

- (CNPayCardModel *)getCardModel {
    CNPayCardModel *card = self.writeModel.cardModel;
    card.totalValue = self.totalValueLb.text;
    card.chargeValue = self.chargeValueLb.text;
    card.actualValue = self.actualValueLb.text;
    card.cardNo = self.cardNumberTF.text;
    card.cardPwd = self.cardPwdTF.text;
    card.payId = self.paymentModel.payid;
    card.amount = [NSString stringWithFormat:@"%.2f", [self.actualValueLb.text floatValue]];
    card.postUrl = self.paymentModel.postUrl;
    return card;
}

@end
