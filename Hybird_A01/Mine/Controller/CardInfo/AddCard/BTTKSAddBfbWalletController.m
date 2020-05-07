//
//  BTTKSAddBfbWalletController.m
//  Hybird_A01
//
//  Created by Levy on 3/31/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTKSAddBfbWalletController.h"
#import "CNPayConstant.h"
#import "IVRsaEncryptWrapper.h"
#import "CLive800Manager.h"

@interface BTTKSAddBfbWalletController ()
@property (weak, nonatomic) IBOutlet UIView *topVIew;
@property (weak, nonatomic) IBOutlet UIView *bindView;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (weak, nonatomic) IBOutlet UIButton *unChoseBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *activeAndBindBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIView *smscodeView;
@property (weak, nonatomic) IBOutlet UIView *codeVIew;
@property (weak, nonatomic) IBOutlet UIButton *smsSendBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeField;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *smsView;
@property (nonatomic, copy) NSString *messageId;
@end

@implementation BTTKSAddBfbWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册币付宝钱包";
    [self setupViews];
}

- (void)contactService{
    [[CLive800Manager sharedInstance] startLive800Chat:self];
}

-(void)setupViews{
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"联系客服" style:UIBarButtonItemStylePlain target:self action:@selector(contactService)];
    self.navigationItem.rightBarButtonItem = bar;
    
    self.view.backgroundColor = kBlackBackgroundColor;
    _topVIew.backgroundColor = kBlackLightColor;
    _bindView.backgroundColor = kBlackBackgroundColor;
    _smscodeView.backgroundColor = kBlackBackgroundColor;
    _codeVIew.backgroundColor = kBlackLightColor;
    _phoneView.backgroundColor = kBlackLightColor;
    _smsView.backgroundColor = kBlackLightColor;
    [_choseBtn setSelected:YES];
    [_unChoseBtn setSelected:NO];
    [_selectedBtn setSelected:YES];
    _activeAndBindBtn.layer.cornerRadius = 4.0;
    _activeAndBindBtn.clipsToBounds = YES;
    _smscodeView.hidden = YES;
    [_bindView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topVIew.mas_bottom);
    }];
    
    self.smsSendBtn.layer.cornerRadius = 6.0;
    self.smsSendBtn.clipsToBounds = YES;
    self.smsSendBtn.backgroundColor = COLOR_RGBA(0, 126, 250, 0.85);
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:
    @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                 NSFontAttributeName:self.phoneTextField.font
         }];
    self.phoneTextField.attributedPlaceholder = attrString;
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:
    @{NSForegroundColorAttributeName:kTextPlaceHolderColor,
                 NSFontAttributeName:self.smsCodeField.font
         }];
    self.smsCodeField.attributedPlaceholder = attrString1;
}
- (IBAction)smsBtn_click:(id)sender {
    [self sendSmsCode];
    
}

- (void)sendSmsCode {
    if ([PublicMethod isValidatePhone:_phoneTextField.text]) {
        [self countDown];
        NSString *phone = _phoneTextField.text;
        NSDictionary *params = @{@"use":@(8),@"mobileNo":[IVRsaEncryptWrapper encryptorString:phone]};
        [IVNetwork requestPostWithUrl:BTTSendMsgCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            NSLog(@"%@",response);
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
                self.messageId = result.body[@"messageId"];
            }else{
                [MBProgressHUD showError:result.head.errMsg toView:nil];
            }
            
        }];
    } else {
        [MBProgressHUD showError:@"请填写正确的手机号" toView:nil];
    }
}

- (void)countDown {
    __block int timeout = 60; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.smsSendBtn.enabled = YES;
                self.smsSendBtn.titleLabel.text = @"重新发送";
                [self.smsSendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.smsSendBtn.backgroundColor = COLOR_RGBA(0, 126, 250, 0.85);
            });
        } else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.smsSendBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@)", strTime];
                [self.smsSendBtn setTitle:[NSString stringWithFormat:@"重新发送(%@)", strTime] forState:UIControlStateNormal];
                self.smsSendBtn.enabled = NO;
                self.smsSendBtn.backgroundColor = [UIColor lightGrayColor];
            });

            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)choseBtn_click:(id)sender {
    if (!_choseBtn.selected) {
        [_choseBtn setSelected:YES];
        [_unChoseBtn setSelected:NO];
        _smscodeView.hidden = YES;
        [_bindView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topVIew.mas_bottom);
        }];
    }
}
- (IBAction)unChoseBtn_click:(id)sender {
    if (!_unChoseBtn.selected) {
        [_choseBtn setSelected:NO];
        [_unChoseBtn setSelected:YES];
        _smscodeView.hidden = NO;
        [_bindView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topVIew.mas_bottom).offset(141);
        }];
    }
}
- (IBAction)selectedBtn_click:(id)sender{
//    [_selectedBtn setSelected:!_selectedBtn.selected];
//    if (_selectedBtn.selected) {
//        [_activeAndBindBtn setTitle:@"激活并绑定" forState:UIControlStateNormal];
//    }else{
//        [_activeAndBindBtn setTitle:@"绑定" forState:UIControlStateNormal];
//    }
}
- (IBAction)activeAndBindBtn_click:(id)sender {
    if (!_choseBtn.selected&&_smsCodeField.text.length==0) {
        [MBProgressHUD showError:@"请输入验证码" toView:nil];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"use"] = @"8";
    if (!_choseBtn.selected) {
        params[@"messageId"] = self.messageId;
        params[@"smsCode"] = _smsCodeField.text;
    }
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCreateBfbAccount paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (self.success) {
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:result.body[@"accountNo"] options:0];
                NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            
                self.success(decodedString);
                
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        
    }];
}
- (IBAction)downLoadBtn_click:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.bitoll.com/ios.html"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
