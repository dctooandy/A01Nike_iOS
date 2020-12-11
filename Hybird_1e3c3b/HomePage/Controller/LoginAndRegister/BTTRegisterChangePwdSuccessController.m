//
//  BTTRegisterChangePwdSuccessController.m
//  Hybird_1e3c3b
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
    [self showCropAlert];
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

- (void)showCropAlert{
    weakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存账号密码截图到相册" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf cropThePasswordView];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cropThePasswordView{
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

@end
