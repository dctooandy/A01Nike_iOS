//
//  BTTLiCaiInDetailPopView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/28/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiInDetailPopView.h"

@interface BTTLiCaiInDetailPopView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, copy) NSString * inputAmountStr;
@end

@implementation BTTLiCaiInDetailPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        self.tipLabel.text = @"请输入转账金额，最少1USDT";
        self.textField.placeholder = @"1USDT";
    } else {
        self.tipLabel.text = @"请输入转账金额，最少1元";
        self.textField.placeholder = @"1元";
    }
    self.textField.delegate = self;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipLabelClick)];
    tap.numberOfTapsRequired = 1;
    [self.tipLabel addGestureRecognizer:tap];
    CGFloat height = KIsiPhoneX ? 355:320;
    self.whiteView.frame = CGRectMake(0, self.frame.size.height + height, SCREEN_WIDTH, height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.whiteView.frame = CGRectMake(0, self.frame.size.height - height, SCREEN_WIDTH, height);
    } completion:nil];
}

- (IBAction)allInBtnClick:(UIButton *)sender {
    if ([self.accountBalance isEqualToString:@"加载中"]) {
        return;
    }
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    NSString * string = self.accountBalance;
    NSArray * array = [string componentsSeparatedByString:@"."];
    if (self.textField.isEditing) {
        self.textField.text = array[0];
    } else {
        self.textField.text = [NSString stringWithFormat:@"%@%@", array[0], unitStr];
    }
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    if (self.closeBtnClickBlock) {
        self.closeBtnClickBlock(sender);
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    if ([self.inputAmountStr floatValue] < 1) {
        NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
        NSString * str = [NSString stringWithFormat:@"输入金额不正确，最少请输入1%@", unitStr];
        [MBProgressHUD showError:str toView:nil];
        return;
    }
    NSString * replacedStr = [self.accountBalance stringByReplacingOccurrencesOfString:@","withString:@""];
    if ([self.inputAmountStr floatValue] > [replacedStr floatValue]) {
        [MBProgressHUD showError:@"转帐金额不能超过账户余额！" toView:nil];
        return;
    }
    if (self.transferBtnClickBlock) {
        self.transferBtnClickBlock(sender, self.inputAmountStr);
    }
}

- (IBAction)cancelAmountBtnClick:(UIButton *)sender {
    self.textField.text = @"";
}

-(void)tipLabelClick {
    [self.textField becomeFirstResponder];
}

-(void)setAccountBalance:(NSString *)accountBalance {
    _accountBalance = accountBalance;
    if ([self.accountBalance isEqualToString:@"加载中"]) {
        self.amountLabel.text = self.accountBalance;
        return;
    }
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    self.amountLabel.text = [NSString stringWithFormat:@"%@%@", [PublicMethod transferNumToThousandFormat:[self.accountBalance doubleValue]], unitStr];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        self.inputAmountStr = textField.text;
        if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
            self.textField.text = [NSString stringWithFormat:@"%@USDT", textField.text];
        } else {
            self.textField.text = [NSString stringWithFormat:@"%@元", textField.text];
        }
        NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
        NSInteger length = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? 4:1;
        NSString * str = [textField.text substringWithRange:NSMakeRange(0,textField.text.length - length)];
        if ([str floatValue] < 1) {
            self.tipLabel.textColor = [UIColor colorWithHexString:@"CC0000"];
            self.tipLabel.text = [NSString stringWithFormat:@"输入金额不正确，最少请输入1%@", unitStr];
        } else {
            self.tipLabel.textColor = [UIColor colorWithHexString:@"999999"];
            self.tipLabel.text = [NSString stringWithFormat:@"请输入转账金额，最少1%@", unitStr];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    if ([self.textField.text rangeOfString:unitStr].location != NSNotFound) {
        NSInteger length = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? 4:1;
        NSString * str = [textField.text substringWithRange:NSMakeRange(0,textField.text.length - length)];
        self.textField.text = str;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"."]) {
        [MBProgressHUD showError:@"转入钱包金额仅支持整数" toView:nil];
        return false;
    } else if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
        NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
        NSString * str = [NSString stringWithFormat:@"输入金额不正确，最少请输入1%@", unitStr];
        [MBProgressHUD showError:str toView:nil];
        return false;
    } else if ([textField.text isEqualToString:@"0"] && string.length > 0) {
        return false;
    }
    return true;
}

@end
