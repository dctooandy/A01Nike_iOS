//
//  BTTPayBQAliStep2VC.m
//  Hybird_A01
//
//  Created by Domino on 29/03/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTPayBQAliStep2VC.h"

@interface BTTPayBQAliStep2VC ()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *payBankNameLb;

@property (weak, nonatomic) IBOutlet UIImageView *bankBGIV;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoIV;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLb;
@property (weak, nonatomic) IBOutlet UILabel *accountLb;

@property (weak, nonatomic) IBOutlet UILabel *accountNameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;


@end

@implementation BTTPayBQAliStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:1000 fullScreen:YES];
    [self configUI];
}

- (void)configUI {
    self.bgView.backgroundColor = kBlackBackgroundColor;
    CNPayBankCardModel *bankModel = self.writeModel.chooseBank;
    self.QRImageView.image = [PublicMethod QRCodeMethod:bankModel.qrCode];
    NSString *amountStr = [NSString stringWithFormat:@"支付金额: ¥%@",bankModel.amount];
    NSRange range = [amountStr rangeOfString:[NSString stringWithFormat:@"¥%@",bankModel.amount]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:amountStr];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffff33"],NSFontAttributeName:[UIFont systemFontOfSize:24]} range:range];
    self.amountLabel.attributedText = attStr;

//    self.payBankNameLb.text = bankModel.bankname;
//    self.depositLb.text = self.writeModel.depositBy;
//    self.amountLb.text = bankModel.amount;

    [self.bankBGIV sd_setImageWithURL:[NSURL URLWithString:bankModel.bankIcon.cn_appendCDN] placeholderImage:[UIImage imageNamed:@"pay_bankBG"]];
    [self.bankLogoIV sd_setImageWithURL:[NSURL URLWithString:bankModel.bankIcon.cn_appendCDN]];
    self.bankNameLb.text = bankModel.bankName;
    self.accountNameLb.text = bankModel.accountName;
    self.accountLb.text  = bankModel.accountNo;
    self.addressLb.text  = bankModel.bankBranchName;
}

- (IBAction)btnClick:(UIButton *)sender {
    [self popToRootViewController];
}

- (IBAction)copyBtnClick:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = _accountLb.text;
    [self showSuccess:@"已复制到剪切板"];
}

- (IBAction)saveErCodeClick:(UIButton *)sender {
    
    UIImageWriteToSavedPhotosAlbum([PublicMethod QRCodeMethod:self.writeModel.chooseBank.qrCode], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"已下载到本地相册" ;
    }
    [MBProgressHUD showSuccess:msg toView:nil];
}


- (IBAction)goToAliBtn:(UIButton *)sender {
//    alipayqr://platformapi/startapp?saId=10000007
    NSString *str = @"alipayqr://platformapi/startapp?saId=10000007";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


@end
