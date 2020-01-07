//
//  BTTMakeCallNoLoginView.m
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMakeCallNoLoginView.h"

@interface BTTMakeCallNoLoginView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextFiled;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImg;
@property (nonatomic, copy) NSString *captchaId;

@end

@implementation BTTMakeCallNoLoginView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.bgImageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [self.bgView addGestureRecognizer:viewTap];
    
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadVerifyCode)];
    [self.captchaImg addGestureRecognizer:tapImg];
    [self loadVerifyCode];
}

- (void)viewTap {
    [self endEditing:YES];
}

// 图形验证码
- (void)loadVerifyCode {
    [IVNetwork requestPostWithUrl:BTTVerifyCaptcha paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        NSLog(@"%@",result.body);
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body && ![result.body isKindOfClass:[NSNull class]]) {
                if (result.body[@"image"] && ![result.body[@"image"] isKindOfClass:[NSNull class]]) {
                    NSString *base64Str = result.body[@"image"];
                    // 将base64字符串转为NSData
                    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                    // 将NSData转为UIImage
                    UIImage *decodedImage = [UIImage imageWithData: decodeData];
                    self.captchaImg.image = decodedImage;
                    //获取到验证码ID
                    self.captchaId = result.body[@"captchaId"];
                }
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
      
    }];
}

- (void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


- (IBAction)callBackBtnClick:(UIButton *)sender {
    [self endEditing:YES];
    if (!self.phoneTextField.text.length) {
        [MBProgressHUD showError:@"请输入您的联系电话" toView:nil];
        return;
    }
    if (!self.captchaTextFiled.text.length) {
        [MBProgressHUD showError:@"请输入验证码" toView:nil];
        return;
    }
    if (self.callBackBlock) {
        self.callBackBlock(self.phoneTextField.text,self.captchaTextFiled.text,self.captchaId);
    }
}
@end
