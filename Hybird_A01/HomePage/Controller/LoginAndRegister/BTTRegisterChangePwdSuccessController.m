//
//  BTTRegisterChangePwdSuccessController.m
//  Hybird_A01
//
//  Created by Domino on 25/04/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTRegisterChangePwdSuccessController.h"

@interface BTTRegisterChangePwdSuccessController ()

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstants;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@end

@implementation BTTRegisterChangePwdSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"注册成功";
    self.imageHeightConstants.constant = SCREEN_WIDTH / 375 * 127;
    NSString *accountStr = [NSString stringWithFormat:@"尊敬的%@,",self.account];
    NSRange range = [accountStr rangeOfString:self.account];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:accountStr];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:range];
    self.accountLabel.attributedText = attStr;
    
}

- (IBAction)toGame:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoHomePageNotification object:nil];
    });
    
}

- (IBAction)moneyBtn:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoMineNotification object:nil];
    });
    
}

@end
