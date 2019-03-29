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


@end

@implementation BTTPayBQAliStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:820 fullScreen:YES];
    [self configUI];
}

- (void)configUI {
    CNPayBankCardModel *bankModel = self.writeModel.chooseBank;
    self.QRImageView.image = [PublicMethod QRCodeMethod:bankModel.qrcode];
    self.amountLabel.text = [NSString stringWithFormat:@"支付金额: ¥%@",bankModel.amount];
}

- (IBAction)btnClick:(UIButton *)sender {
    [self popToRootViewController];
}

@end
