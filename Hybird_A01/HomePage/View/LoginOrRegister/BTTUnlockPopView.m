//
//  BTTUnlockPopView.m
//  Hybird_A01
//
//  Created by Domino on 13/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTUnlockPopView.h"

@interface BTTUnlockPopView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *infoTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation BTTUnlockPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.infoTextField.delegate = self;
}


- (IBAction)confrimClick:(UIButton *)sender {
    if (self.nameTextField.text.length || self.phoneTextField.text.length || self.infoTextField.text.length) {
        [self unluckAccountWithName:self.nameTextField.text phone:self.phoneTextField.text info:self.infoTextField.text loginName:self.account];
    } else {
        [MBProgressHUD showError:@"请输入任一信息解锁" toView:nil];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)unluckAccountWithName:(NSString *)name
                        phone:(NSString *)phone
                         info:(NSString *)info
                    loginName:(NSString *)loginName {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (name.length) {
        [params setObject:name forKey:@"realname"];
    }
    if (phone.length) {
        [params setObject:phone forKey:@"bingphone"];
    }
//    if (info.length) {
//        [params setObject:info forKey:@"reserved"];
//    }
    [params setObject:loginName forKey:@"loginname"];
    
    [IVNetwork sendRequestWithSubURL:BTTUnlockAccount paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.status) {
            
            if (result.data) {
                [MBProgressHUD showError:@"已解锁，请重新登录！" toView:nil];
                if (self.dismissBlock) {
                    self.dismissBlock();
                }
            } else {
                [MBProgressHUD showError:@"验证失败，请重试！" toView:nil];
            }
        }
        
    }];
}


@end
