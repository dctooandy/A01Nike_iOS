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

@end

@implementation BTTPayBQAliStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:860 fullScreen:YES];
    [self configUI];
}

- (void)configUI {
    self.bgView.backgroundColor = kBlackBackgroundColor;
    CNPayBankCardModel *bankModel = self.writeModel.chooseBank;
    self.QRImageView.image = [PublicMethod QRCodeMethod:bankModel.qrcode];
    NSString *amountStr = [NSString stringWithFormat:@"支付金额: ¥%@",bankModel.amount];
    NSRange range = [amountStr rangeOfString:[NSString stringWithFormat:@"¥%@",bankModel.amount]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:amountStr];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffff33"],NSFontAttributeName:[UIFont systemFontOfSize:24]} range:range];
    self.amountLabel.attributedText = attStr;
}

- (IBAction)btnClick:(UIButton *)sender {
    [self popToRootViewController];
}

@end
