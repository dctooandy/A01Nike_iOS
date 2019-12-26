//
//  CNPayUSDTQRSecondVC.m
//  Hybird_A01
//
//  Created by Levy on 12/24/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "CNPayUSDTQRSecondVC.h"
#import "CNPayDepositTipView.h"

@interface CNPayUSDTQRSecondVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *walletAddressInputField;
@property (weak, nonatomic) IBOutlet UITextField *saveInputField;
@property (weak, nonatomic) IBOutlet UILabel *recivedAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, assign) CGFloat usdtRate;
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
    if (_walletAddressInputField.text.length<5) {
        [self showError:@"钱包地址不得少于5位"];
    }else if (_saveInputField.text.length==0||[_saveInputField.text doubleValue]==0){
        [self showError:@"请填写大于0的存款金额"];
    }else{
        [self submitManualPayOrder];
    }
}

- (void)submitManualPayOrder{
    NSString *text = [[NSUserDefaults standardUserDefaults]objectForKey:@"manual_usdt_note"];
    text = [text substringWithRange:NSMakeRange(3, text.length-3)];
    [self showLoading];
    weakSelf(weakSelf);
    [CNPayRequestManager usdtManualPayHandleWithBankAccountNo:_walletAddressInputField.text amount:_saveInputField.text remark:text completeHandler:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",result);
        [self hideLoading];
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (result.status) {
//            [strongSelf paySucessHandler:result repay:nil];
//        }else{
//            [self showError:result.message];
//        }
        if (!result.status) {
            [weakSelf showError:result.message];
            return;
        }
//        NSArray *array = (NSArray *)[result.data objectForKey:@"list"];
//        if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
//            [weakSelf showError:@"您还有未处理的存款提案，请联系客服"];
//            return;
//        }
        [CNPayDepositTipView showTipViewFinish:^{
            [weakSelf goToStep:2];
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
    
    
    NSAttributedString *addressString = [[NSAttributedString alloc] initWithString:@"您转账的钱包地址，最少输入前5位" attributes:
    @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                 NSFontAttributeName:_walletAddressInputField.font
         }];
    _walletAddressInputField.attributedPlaceholder = addressString;
    
    NSAttributedString *amountString = [[NSAttributedString alloc] initWithString:@"请输入存款金额" attributes:
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
