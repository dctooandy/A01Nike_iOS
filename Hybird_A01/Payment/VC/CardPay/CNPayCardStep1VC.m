//
//  CNPayCardStep1VC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/24.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayCardStep1VC.h"
#import "UIButton+WebCache.h"

@interface CNPayCardStep1VC ()
@property (weak, nonatomic) IBOutlet UIView *preSettingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preSettingViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *preSettingMessageLb;

@property (weak, nonatomic) IBOutlet UITextField *cardTypeTF;
@property (weak, nonatomic) IBOutlet UIImageView *cardLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLb;


@property (nonatomic, strong) CNPayCardModel *chooseCardModel;
@end

@implementation CNPayCardStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configPreSettingMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:500 fullScreen:NO];
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
    NSMutableArray *cardTypeArr = [NSMutableArray array];
    for (CNPayCardModel *model in self.paymentModel.cardList) {
        [cardTypeArr addObject:model.name];
    }
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:@"请选择点卡类型" dataSource:cardTypeArr defaultSelValue:_cardTypeTF.text resultBlock:^(id selectValue, NSInteger index) {
        weakSelf.cardTypeTF.hidden = YES;
        CNPayCardModel *model = weakSelf.paymentModel.cardList[index];
        [weakSelf.cardLogoIV sd_setImageWithURL:[NSURL URLWithString:model.logo.cn_appendCDN]];
        weakSelf.cardTypeLb.text = model.name;
        weakSelf.chooseCardModel = model;
    }];
}

- (IBAction)submitAction:(UIButton *)sender {
    if (!self.chooseCardModel) {
        [self showError:self.cardTypeTF.placeholder];
        return;
    }
    self.writeModel.cardModel = self.chooseCardModel;
    [self goToStep:1];
}
@end
