//
//  BTTNicknameSetController.m
//  Hybird_A01
//
//  Created by Domino on 25/04/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTNicknameSetController.h"

@interface BTTNicknameSetController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextField *nicknameField;

@end

@implementation BTTNicknameSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self setupUI];
}

- (void)setupUI {
    self.nicknameField.delegate = self;
    self.view.backgroundColor = COLOR_RGBA(36, 40, 49, 1);;
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    NSMutableAttributedString * attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入3-8个汉字 (不要使用真实姓名)" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"818791"]}];
    _nicknameField.attributedPlaceholder = attributedPlaceholder;
}


- (IBAction)cancelClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)confirmClick:(UIButton *)sender {
    [self setNickNameWithNickname:self.nicknameField.text];
}


- (void)setNickNameWithNickname:(NSString *)nickname {
    if (nickname.length < 3 || nickname.length > 8) {
        [MBProgressHUD showError:@"昵称为3-8个汉字" toView:self.view];
        return;
    }
    if (!nickname.length) {
        [MBProgressHUD showError:@"昵称不能为空" toView:self.view];
        return;
    }
    if (![PublicMethod isChinese:nickname]) {
        [MBProgressHUD showError:@"昵称只能为汉字" toView:self.view];
        return;
    }
    
    NSDictionary *params = @{@"nick_name":nickname};
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTSetNickname paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        if (result.status) {
            NSLog(@"%@",response);
            [MBProgressHUD showSuccess:@"恭喜, 设置成功! 您可以使用昵称登录APP" toView:nil];
            [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:BTTNicknameCache];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            if (result.message.length) {
                [MBProgressHUD showError:result.message toView:self.view];
            }
        }
    }];
}

#pragma mark - textfielddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

@end
