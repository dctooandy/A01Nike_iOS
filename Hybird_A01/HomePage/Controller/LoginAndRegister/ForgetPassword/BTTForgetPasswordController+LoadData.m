//
//  BTTForgetPasswordController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordController+LoadData.h"
#import "BTTMeMainModel.h"


@implementation BTTForgetPasswordController (LoadData)


// 图形验证码
- (void)loadVerifyCode {
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTVerifyCaptcha paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body && ![result.body isKindOfClass:[NSNull class]]) {
                if (result.body[@"image"] && ![result.body[@"image"] isKindOfClass:[NSNull class]]) {
                    NSString *base64Str = result.body[@"image"];
                    // 将base64字符串转为NSData
                    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                    // 将NSData转为UIImage
                    UIImage *decodedImage = [UIImage imageWithData: decodeData];
                    self.codeImage = decodedImage;
                    //获取到验证码ID
                    self.uuid = result.body[@"captchaId"];
                    self.codeImage = decodedImage;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                }
            }
        }
    }];
}

- (void)verifyPhotoCode:(NSString *)code loginName:(NSString *)loginName WithCaptchaId:(NSString *)captchaId completeBlock:(KYHTTPCallBack)completeBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:code forKey:@"captcha"];
    [params setValue:captchaId forKey:@"captchaId"];
    [params setValue:@0 forKey:@"type"];
    [params setValue:loginName forKey:@"loginName"];
    [IVNetwork requestPostWithUrl:BTTValidateCaptcha paramters:params completionBlock:completeBlock];
}

- (void)loadMainData {
    NSArray *names = @[@"登录账号",@"验证码"];
    NSArray *placeholds = @[@"请输入账号",@"请输入验证码"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholds[index];
        [self.mainData addObject:model];
    }
    [self setupElements];
}

- (void)setMainData:(NSMutableArray *)mainData {
    objc_setAssociatedObject(self, @selector(mainData), mainData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)mainData {
    NSMutableArray *mainData = objc_getAssociatedObject(self, _cmd);
    if (!mainData) {
        mainData = [NSMutableArray array];
        [self setMainData:mainData];
    }
    return mainData;
}


@end

