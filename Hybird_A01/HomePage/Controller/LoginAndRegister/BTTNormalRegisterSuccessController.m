//
//  BTTNormalRegisterSuccessController.m
//  Hybird_A01
//
//  Created by Levy on 3/3/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTNormalRegisterSuccessController.h"
#import "IVRsaEncryptWrapper.h"

@interface BTTNormalRegisterSuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeField;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *goToGameView;
@property (weak, nonatomic) IBOutlet UIView *bindView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@property (nonatomic, copy) NSString *messageId;
@property (assign, nonatomic) int timeOut;
@end

@implementation BTTNormalRegisterSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor blackColor];

    self.smsBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.smsBtn.layer.borderWidth = 0.5;
    self.smsBtn.layer.cornerRadius = 12.5;
    self.smsBtn.clipsToBounds = YES;

    self.accountLabel.text = self.account;
    self.pwdLabel.text = self.pwd;
    
    self.confirmBtn.layer.cornerRadius = 20.0;
    self.confirmBtn.clipsToBounds = YES;
}

- (IBAction)jumpBtn_click:(id)sender {
    [self showCropAlert];
    self.goToGameView.hidden = NO;
    self.bindView.hidden = YES;
}

- (IBAction)confirmBtn_click:(id)sender {
    NSString *url = BTTBindPhone;
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"messageId"] = self.messageId;
    params[@"smsCode"] = [self smsCodeField].text;
    NSString *successStr = @"绑定成功";
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView: self.view animated: YES];
    [IVNetwork requestPostWithUrl:url paramters:params completionBlock:^(id _Nullable response, NSError *_Nullable error) {
        IVJResponseObject *result = response;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (successStr) {
                [MBProgressHUD showSuccess:successStr toView:nil];
                self.goToGameView.hidden = NO;
                self.bindView.hidden = YES;
                self.jumpBtn.hidden = YES;
                [self showCropAlert];
            }
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (IBAction)sendSmsBtn_click:(id)sender {
    if ([PublicMethod isValidatePhone:_phoneField.text]) {
        [self.view endEditing:YES];
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"use"] = @"3";
        params[@"mobileNo"] = [IVRsaEncryptWrapper encryptorString:_phoneField.text];
        weakSelf(weakSelf)
        [MBProgressHUD showLoadingSingleInView: self.view animated: YES];
        [IVNetwork requestPostWithUrl:BTTSendMsgCode paramters:params completionBlock:^(id _Nullable response, NSError *_Nullable error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
                self.messageId = result.body[@"messageId"];
                [weakSelf countDown];
                [self.smsCodeField becomeFirstResponder];
            } else {
                [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
            }
        }];
    } else {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:nil];
    }
}

- (void)showCropAlert {
    weakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存账号密码到相册" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [weakSelf cropThePasswordView];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cropThePasswordView {
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [self.view.layer renderInContext:ctx];
    //iOS7+ 推荐使用的方法，代替上述方法
    // [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    // 保存相册
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
}

- (void)countDown
{
    self.timeOut = 60;
    [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeSendNotification object:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (self.timeOut <= -100) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.timeOut = 60;
                self.smsBtn.enabled = NO;
                self.smsBtn.titleLabel.text = @"发送验证码";
                [self.smsBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
        } else if (self.timeOut <= 0 && self.timeOut > -100) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.timeOut = 60;
                self.smsBtn.enabled = YES;
                self.smsBtn.titleLabel.text = @"重新发送";
                [self.smsBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            });
        } else {
            int seconds = self.timeOut;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.smsBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@)", strTime];
                [self.smsBtn setTitle:[NSString stringWithFormat:@"重新发送(%@)", strTime] forState:UIControlStateNormal];

                self.smsBtn.enabled = NO;
            });

            self.timeOut--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)goGameCenter:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoHomePageNotification object:nil];
    });
}
- (IBAction)goToRecharge:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoMineNotification object:nil];
    });
}

@end
