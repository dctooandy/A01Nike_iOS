//
//  CNPayUSDTQRSecondVC.m
//  Hybird_A01
//
//  Created by Levy on 12/24/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "CNPayUSDTQRSecondVC.h"

@interface CNPayUSDTQRSecondVC ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *tradeIdInputField;
@property (weak, nonatomic) IBOutlet UITextField *walletAddressInputField;
@property (weak, nonatomic) IBOutlet UITextField *saveInputField;
@property (weak, nonatomic) IBOutlet UILabel *recivedAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation CNPayUSDTQRSecondVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:360 fullScreen:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)confirmBtn_click:(id)sender {
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
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"交易ID，最少输入前5位" attributes:
    @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                 NSFontAttributeName:_tradeIdInputField.font
         }];
    _tradeIdInputField.attributedPlaceholder = attrString;
    
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
}

@end
