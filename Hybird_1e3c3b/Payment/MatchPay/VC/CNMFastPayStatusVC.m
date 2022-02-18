//
//  CNMFastPayStatusVC.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/17/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMFastPayStatusVC.h"

@interface CNMFastPayStatusVC ()

#pragma mark - 顶部状态试图
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *statusIVs;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *statusLbs;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
/// 时间前面
@property (weak, nonatomic) IBOutlet UILabel *tip1Lb;
/// 时间标签
@property (weak, nonatomic) IBOutlet UILabel *tip2Lb;
/// 时间后面
@property (weak, nonatomic) IBOutlet UILabel *tip3Lb;
/// 时间下面
@property (weak, nonatomic) IBOutlet UILabel *tip4Lb;
/// 大字提示语
@property (weak, nonatomic) IBOutlet UILabel *tip5Lb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip5LbH;

#pragma mark - 中间金额视图
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UILabel *amountTipLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountTipLbH;

#pragma mark - 中间银行卡视图，一共有7行信息栏
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIView *bankRow5;
@property (weak, nonatomic) IBOutlet UIView *bankRow6;
@property (weak, nonatomic) IBOutlet UIView *bankRow7;
@property (weak, nonatomic) IBOutlet UILabel *rowTitle6;

@property (weak, nonatomic) IBOutlet UIImageView *bankLogo;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountNo;
@property (weak, nonatomic) IBOutlet UILabel *bankAmount;
@property (weak, nonatomic) IBOutlet UILabel *submitDate;
/// 确认时间/订单编号公用
@property (weak, nonatomic) IBOutlet UILabel *confirmDate;
/// 复制内容标签组
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray <UILabel *> *contentLbArray;


#pragma mark - 底部提示内容
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (weak, nonatomic) IBOutlet UIView *submitTipView;
@property (weak, nonatomic) IBOutlet UIView *confirmTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmTipViewH;

#pragma mark - 底部按钮组
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *customerServerBtn;

#pragma mark - 相册选择
@property (strong, nonatomic) IBOutlet UIView *pictureView;
/// 上面一个按钮
@property (weak, nonatomic) IBOutlet UIButton *pictureBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLb1;
/// 下面面按钮组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pictureBtnArr;
@property (weak, nonatomic) IBOutlet UILabel *countLb2;
@end

@implementation CNMFastPayStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setStatusUI:self.status];
}

- (void)setupUI {
    self.bankView.layer.borderWidth = 1;
    self.bankView.layer.borderColor = kHexColor(0x3A3D46).CGColor;
    self.bankView.layer.cornerRadius = 8;
    
    self.clockView.layer.borderWidth = 1;
    self.clockView.layer.borderColor = kHexColor(0x0994E7).CGColor;
    self.clockView.layer.cornerRadius = 8;
    
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.borderColor = kHexColor(0xF2DA0F).CGColor;
    self.cancelBtn.layer.cornerRadius = 8;
}

- (void)setStatusUI:(CNMPayStatus)status {
    self.status = status;
    for (int i = 0; i <= status; i++) {
        if (i >= self.statusIVs.count) {
            break;
        }
        UIImageView *iv = self.statusIVs[i];
        [iv setHighlighted:YES];
        UILabel *label = self.statusLbs[i];
        label.textColor = kHexColor(0xD2D2D2);
    }
    
    switch (status) {
        case CNMPayStatusConfirm:
            self.title = @"待确认到账";
            self.headerH.constant = 140;
            self.tip1Lb.text = @"已等待";
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = YES;
            
            self.bankRow5.hidden = NO;
            self.bankRow6.hidden = NO;
            self.bankRow7.hidden = YES;
            
            self.submitTipView.hidden = YES;
            self.confirmTipView.hidden = NO;
            
            self.btnView.hidden = YES;
            self.customerServerBtn.hidden = NO;
            self.customerServerBtn.enabled = YES;
            break;
        case CNMPayStatusSuccess:
            self.title = @"存款完成";
            self.headerH.constant = 140;
            self.tip1Lb.hidden = YES;
            self.tip2Lb.hidden = YES;
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = NO;
            self.tip5Lb.textColor = kHexColor(0x818791);
            self.tip5Lb.text = @"您完成了一笔存款";
            self.tip5LbH.constant = 16;
            
            self.amountTitleLb.hidden = YES;
            self.amountTipLb.hidden = NO;
            self.amountTipLbH.constant = 50;
            
            self.bankRow5.hidden = YES;
            self.bankRow6.hidden = NO;
            self.bankRow7.hidden = YES;
            self.rowTitle6.text = @"订单编号：";
            
            self.submitTipView.hidden = YES;
            self.confirmTipView.hidden = YES;
            self.confirmTipViewH.constant = 0;
            self.btnView.hidden = YES;
            self.customerServerBtn.hidden = NO;
            self.customerServerBtn.enabled = YES;
            [self.customerServerBtn setTitle:@"返回首页" forState:UIControlStateNormal];
            break;
        default:
            self.title = @"等待存款";
            self.amountTipLb.hidden = YES;
            self.amountTipLbH.constant = 0;
            self.submitTipView.hidden = NO;
            
            self.bankRow5.hidden = YES;
            self.bankRow6.hidden = YES;
            self.bankRow7.hidden = NO;
            
            self.confirmTipView.hidden = YES;
            self.customerServerBtn.hidden = YES;
            break;
    }
}

#pragma mark - 按钮组事件
- (IBAction)cancel:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消存款" message:@"老板！如已存款，请不要取消" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *commit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:commit];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)confirm:(UIButton *)sender {
    [self setStatusUI:CNMPayStatusConfirm];
}

- (IBAction)customerServer:(UIButton *)sender {
    if (self.status == CNMPayStatusSuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self setStatusUI:CNMPayStatusSuccess];
}

- (IBAction)copyContent:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.contentLbArray[sender.tag].text;
    [self showSuccess:@"复制成功"];
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/// 选择相册
- (IBAction)selectSinglePicture:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        return;
    }
    
}


- (IBAction)selectPictures:(UIButton *)sender {
}


@end
