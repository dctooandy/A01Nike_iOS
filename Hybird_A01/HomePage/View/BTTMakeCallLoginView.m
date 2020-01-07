//
//  BTTMakeCallLoginView.m
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMakeCallLoginView.h"

@interface BTTMakeCallLoginView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *captchaTextFiled;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImg;
@property (nonatomic, copy) NSString *captchaId;
@end

@implementation BTTMakeCallLoginView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([IVNetwork savedUserInfo].mobileNo.length) {
        self.titleLabel.text = [NSString stringWithFormat:@"您绑定的电话为: %@*****%@",[[IVNetwork savedUserInfo].mobileNo substringToIndex:3],[[IVNetwork savedUserInfo].mobileNo substringFromIndex:8]];
    } else {
        self.titleLabel.text = @"您未绑定手机, 请选择其他电话";
    }
    self.bgView.layer.cornerRadius = 6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.bgImageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadVerifyCode)];
    [self.captchaImg addGestureRecognizer:tapImg];
    [self loadVerifyCode];
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

- (IBAction)confirmClick:(UIButton *)sender {
//    if (self.btnBlock) {
//        self.btnBlock(sender);
//    }
    if (!self.captchaTextFiled.text.length) {
        [MBProgressHUD showError:@"请输入验证码" toView:nil];
        return;
    }
    if (self.callBackBlock) {
        self.callBackBlock(@"",self.captchaTextFiled.text,self.captchaId);
    }
}

- (IBAction)otherClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}


@end
