//
//  CNPayCardStep1VC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/24.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayCardStep1VC.h"
#import "UIButton+WebCache.h"
#import "BTTPointCardModel.h"

@interface CNPayCardStep1VC ()
@property (weak, nonatomic) IBOutlet UIView *preSettingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preSettingViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *preSettingMessageLb;

@property (weak, nonatomic) IBOutlet UITextField *cardTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *cardValueTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNoTF;
@property (weak, nonatomic) IBOutlet UITextField *cardPwdTF;

@property (nonatomic, strong) BTTPointCardListModel *listModel;
@property (nonatomic, strong) BTTPointCardModel *chooseCardModel;
@end

@implementation CNPayCardStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configPreSettingMessage];
    [self queryPointCardList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:350 fullScreen:NO];
}

- (void)queryPointCardList{
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTQueryPointCardList paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            weakSelf.listModel = [BTTPointCardListModel yy_modelWithJSON:result.body];
            
        }
    }];
}

- (void)configPreSettingMessage {
    if (self.preSaveMsg.length > 0) {
        self.preSettingMessageLb.text = self.preSaveMsg;
        self.preSettingViewHeight.constant = 50;
        self.preSettingView.hidden = NO;
    } else {
        self.preSettingViewHeight.constant = 0;
        self.preSettingView.hidden = YES;
    }
}

// 选择点卡类型
- (IBAction)selectCard:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableArray *cardTypeArr = [NSMutableArray array];
    for (BTTPointCardModel *model in self.listModel.pointCardList) {
        [cardTypeArr addObject:model.name];
    }
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:_cardTypeTF.placeholder dataSource:cardTypeArr defaultSelValue:_cardTypeTF.text resultBlock:^(NSString *selectValue, NSInteger index) {
        weakSelf.cardTypeTF.text = selectValue;
        BTTPointCardModel *model = [BTTPointCardModel yy_modelWithJSON:weakSelf.listModel.pointCardList[index]];
        weakSelf.chooseCardModel = model;
        weakSelf.cardValueTF.text = nil;
    }];
}

/// 选择点卡面额
- (IBAction)selectCardValue:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!_chooseCardModel) {
        [self showError:_cardTypeTF.placeholder];
        return;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.chooseCardModel.cardValues.count];
    for (id obj in self.chooseCardModel.cardValues) {
        [array addObject:[NSString stringWithFormat:@"%@", obj]];
    }
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:_cardValueTF.placeholder dataSource:array defaultSelValue:_cardValueTF.text resultBlock:^(NSString * selectValue, NSInteger index) {
        weakSelf.cardValueTF.text = selectValue;
    }];
}


- (IBAction)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!_chooseCardModel) {
        [self showError:_cardTypeTF.placeholder];
        return;
    }
    
    if (_cardValueTF.text.length == 0) {
        [self showError:_cardValueTF.placeholder];
        return;
    }
    
    if (_cardNoTF.text.length == 0) {
        [self showError:_cardNoTF.placeholder];
        return;
    }
    
    if (_cardPwdTF.text.length == 0) {
        [self showError:_cardPwdTF.placeholder];
        return;
    }
    
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    /// 提交
    __weak typeof(self) weakSelf =  self;
    NSDictionary *params = @{
        @"cardNo":_cardNoTF.text,
        @"payId":self.listModel.payid,
        @"amount":_cardValueTF.text,
        @"cardPwd":_cardPwdTF.text,
        @"cardCode":self.chooseCardModel.code
    };
    [IVNetwork requestPostWithUrl:BTTPointCardPayment paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            CNPayOrderModel *model = [[CNPayOrderModel alloc] initWithDictionary:result.body error:nil];
            weakSelf.writeModel.orderModel = model;
            [self pushUIWebViewWithURLString:@"" title:self.paymentModel.payTypeName];
        }else{
            [self showError:result.head.errMsg];
        }
    }];

}
@end
