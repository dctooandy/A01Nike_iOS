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
    [IVNetwork sendRequestWithSubURL:BTTVerifyCaptcha paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        if (result.status && result.data && ![result.data isKindOfClass:[NSNull class]]) {
            if (result.data[@"src"] && ![result.data[@"src"] isKindOfClass:[NSNull class]]) {
                NSString *base64Str = result.data[@"src"];
                self.uuid = result.data[@"uuid"];
                // 将base64字符串转为NSData
                NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                // 将NSData转为UIImage
                UIImage *decodedImage = [UIImage imageWithData: decodeData];
                self.codeImage = decodedImage;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }
    }];
}

- (void)verifyPhotoCode:(NSString *)code WithUUid:(NSString *)uuid completeBlock:(CompleteBlock)completeBlock {
    NSDictionary *params = @{@"code":code,@"uuid":uuid};
    [IVNetwork sendRequestWithSubURL:BTTValidateCaptcha paramters:params completionBlock:completeBlock];
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
