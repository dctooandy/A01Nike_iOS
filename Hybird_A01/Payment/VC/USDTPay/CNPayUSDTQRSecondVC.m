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

#define NUM @"0123456789."//只输入数字
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"//数字和字母

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
    if (_walletAddressInputField.text.length<6||_walletAddressInputField.text.length>100) {
        [self showError:@"请输入长度为6-100位钱包地址"];
        return;
    }

    NSString *protocol = [[NSUserDefaults standardUserDefaults]objectForKey:@"usdt_protocol"];
    NSString *firstChar = @"";
    NSString *firstTwoChar = @"";
    if (![_walletAddressInputField.text isEqualToString:@""]) {
        firstChar = [_walletAddressInputField.text substringWithRange:NSMakeRange(0, 1)];
        firstTwoChar = [_walletAddressInputField.text substringWithRange:NSMakeRange(0, 2)];
    }
    if (_saveInputField.text.length==0||[_saveInputField.text doubleValue]==0){
        [self showError:@"存款金额不得小于1"];
    }else if ([protocol isEqualToString:@"OMNI"]&&!([firstChar isEqualToString:@"1"]||[firstChar isEqualToString:@"3"])){
        [MBProgressHUD showError:@"OMNI协议钱包，请以1或3开头" toView:self.view];
    }else if ([protocol isEqualToString:@"ERC20"]&&![firstChar isEqualToString:@"0x"]){
        [MBProgressHUD showError:@"ERC20协议钱包，请以0x开头" toView:self.view];
    }else{
        [self submitManualPayOrder];
    }
}

- (void)submitManualPayOrder{
    NSString *text = [[NSUserDefaults standardUserDefaults]objectForKey:@"manual_usdt_note"];
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:@"manual_usdt_account"];
    NSString *bankCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"manual_usdt_bankCode"];
    NSString *protocol = [[NSUserDefaults standardUserDefaults]objectForKey:@"usdt_protocol"];
    [self showLoading];
    weakSelf(weakSelf);
    NSDictionary *params = @{
        @"virtualUrl" : _walletAddressInputField.text,
        @"depositType" : bankCode,
        @"depositDate" : [PublicMethod getCurrentTimesWithFormat:@"yyyy-MM-dd hh:mm:ss"],
        @"amount" : _saveInputField.text,
        @"accountNo" : account,
        @"retelling" : text,
        @"loginName" : [IVNetwork savedUserInfo].loginName,
        @"protocol" : protocol
    };
    [IVNetwork requestPostWithUrl:BTTManualPay paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            CNPayDepositSuccessVC *successVC = [[CNPayDepositSuccessVC alloc] initWithAmount:weakSelf.recivedAmountLabel.text];
            [weakSelf pushViewController:successVC];
        }else{
            [weakSelf showError:result.head.errMsg];
            return;
        }
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
    gradientLayer0.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 44);
    gradientLayer0.colors = @[
        (id)[UIColor colorWithRed:247.0f/255.0f green:249.0f/255.0f blue:82.0f/255.0f alpha:1.0f].CGColor,
        (id)[UIColor colorWithRed:242.0f/255.0f green:218.0f/255.0f blue:15.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(1, 1)];
    [gradientLayer0 setEndPoint:CGPointMake(0, 0)];
    [_confirmBtn.layer addSublayer:gradientLayer0];
    
    
    NSAttributedString *addressString = [[NSAttributedString alloc] initWithString:@"您转账的钱包地址6-100位" attributes:
    @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                 NSFontAttributeName:_walletAddressInputField.font
         }];
    _walletAddressInputField.attributedPlaceholder = addressString;
    
    NSAttributedString *amountString = [[NSAttributedString alloc] initWithString:@"最低1，最高999999999" attributes:
    @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                 NSFontAttributeName:_saveInputField.font
         }];
    _saveInputField.attributedPlaceholder = amountString;
    
    
    NSString *verifyCode = [IVNetwork savedUserInfo].verifyCode ? [IVNetwork savedUserInfo].verifyCode : @"";
    NSString *realName = [IVNetwork savedUserInfo].loginName ? [IVNetwork savedUserInfo].loginName : @"";
    
    _infoLabel.text = [NSString stringWithFormat:@"  %@  ",verifyCode];
    _accountNameLabel.text = realName;
    
    _walletAddressInputField.delegate = self;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_walletAddressInputField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else{
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
       
        if (toString.length > 0) {

        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,9}(([.]\\d{0,2})?)))?";

        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];

        BOOL flag = [phoneTest evaluateWithObject:toString];

        if (!flag) {

        return NO;

        }

        }
        return YES;
    }
    
}

@end
