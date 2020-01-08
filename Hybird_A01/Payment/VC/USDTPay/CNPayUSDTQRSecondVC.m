//
//  CNPayUSDTQRSecondVC.m
//  Hybird_A01
//
//  Created by Levy on 12/24/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "CNPayUSDTQRSecondVC.h"
#import "CNPayDepositTipView.h"
#import "CNPayDepositSuccessVC.h"

@interface CNPayUSDTQRSecondVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *walletAddressInputField;
@property (weak, nonatomic) IBOutlet UITextField *saveInputField;
@property (weak, nonatomic) IBOutlet UILabel *recivedAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, assign) CGFloat usdtRate;
@property (nonatomic, copy) NSString *minamount;
@property (nonatomic, copy) NSString *maxamount;
@end

@implementation CNPayUSDTQRSecondVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:360 fullScreen:NO];
    
    _usdtRate = [[NSUserDefaults standardUserDefaults]floatForKey:@"manual_usdt_rate"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)confirmBtn_click:(id)sender {
    if (_walletAddressInputField.text.length<6||_walletAddressInputField.text.length>40) {
        [self showError:@"请输入长度为6-40位钱包地址"];
    }else if (_saveInputField.text.length==0||[_saveInputField.text doubleValue]==0){
        [self showError:@"请填写大于0的存款金额"];
    }else{
        [self submitManualPayOrder];
    }
}

- (void)submitManualPayOrder{
    NSString *text = [[NSUserDefaults standardUserDefaults]objectForKey:@"manual_usdt_note"];
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:@"manual_usdt_account"];
    text = [text substringWithRange:NSMakeRange(3, text.length-3)];
    
    [self showLoading];
    weakSelf(weakSelf);
    [CNPayRequestManager usdtManualPayHandleWithBankAccountNo:account userAccountNo:_walletAddressInputField.text amount:_saveInputField.text remark:text completeHandler:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",result);
        [self hideLoading];
        if (!result.status) {
            [weakSelf showError:result.message];
            return;
        }
        [CNPayDepositTipView showTipViewFinish:^{
//            [weakSelf goToStep:2];
            CNPayDepositSuccessVC *successVC = [[CNPayDepositSuccessVC alloc] initWithAmount:weakSelf.recivedAmountLabel.text];
            [weakSelf pushViewController:successVC];
        }];
    }];
}


- (void)setupView{
    self.view.backgroundColor = kBlackBackgroundColor;
    self.infoView.layer.backgroundColor = [[UIColor colorWithRed:41.0f/255.0f green:45.0f/255.0f blue:54.0f/255.0f alpha:1.0f] CGColor];
    
    self.infoLabel.backgroundColor = COLOR_RGBA(54, 54, 76, 1);
    
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
    _confirmBtn.alpha = 1;

    //Gradient 0 fill for 圆角矩形 11
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 5;
    gradientLayer0.frame = _confirmBtn.bounds;
    gradientLayer0.colors = @[
        (id)[UIColor colorWithRed:247.0f/255.0f green:249.0f/255.0f blue:82.0f/255.0f alpha:1.0f].CGColor,
        (id)[UIColor colorWithRed:242.0f/255.0f green:218.0f/255.0f blue:15.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(1, 1)];
    [gradientLayer0 setEndPoint:CGPointMake(0, 0)];
    [_confirmBtn.layer addSublayer:gradientLayer0];
    
    
    NSAttributedString *addressString = [[NSAttributedString alloc] initWithString:@"您转账的钱包地址6-40位" attributes:
    @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                 NSFontAttributeName:_walletAddressInputField.font
         }];
    _walletAddressInputField.attributedPlaceholder = addressString;
    
    _minamount = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"usdt_minamount"]];
    _maxamount = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"usdt_maxamount"]];
    NSAttributedString *amountString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"最低%@，最高%@",self.minamount,self.maxamount] attributes:
    @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                 NSFontAttributeName:_saveInputField.font
         }];
    _saveInputField.attributedPlaceholder = amountString;
    
    NSString *verifyCode = [IVNetwork userInfo].verify_code ? [IVNetwork userInfo].verify_code : @"";
    NSString *realName = [IVNetwork userInfo].loginName ? [IVNetwork userInfo].loginName : @"";
    
    _infoLabel.text = [NSString stringWithFormat:@"  %@  ",verifyCode];
    _accountNameLabel.text = realName;
    
    _saveInputField.delegate = self;
    [_saveInputField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChanged:(id)sender{
    if (_saveInputField.text.length>0) {
        CGFloat rmbCash = [_saveInputField.text integerValue] * self.usdtRate;
        _recivedAmountLabel.text = [NSString stringWithFormat:@"%.2f",rmbCash];
    }else{
        _recivedAmountLabel.text = @"0";
    }
}

@end
