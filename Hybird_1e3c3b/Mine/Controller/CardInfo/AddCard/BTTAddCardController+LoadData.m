//
//  BTTAddCardController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddCardController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTAddCardController+Nav.h"
#import "NSString+CNPayment.h"
@implementation BTTAddCardController (LoadData)

-(void)loadQueryBanks {
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTQueryBanks paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            for (NSDictionary * dict in result.body) {
                if (dict[@"bankName"]) {
                    NSString * nameStr = dict[@"bankName"];
                    if (nameStr.length > 0) {
                        [self.bankNamesArr addObject:nameStr];
                    }
                    NSString * iconStr = dict[@"bankIcon"];
                    if (iconStr.length >= 0) {
                        [self.bankIconArr addObject:[PublicMethod nowCDNWithUrl:iconStr]];
                    }
                }
            }
        }
        [self.collectionView reloadData];
    }];
}

- (void)loadMainData {
    NSArray *names = @[@"持卡人姓名",@"开户行",@"卡片类别",@"卡号",@"开户省份",@"开户城市",@"开户网点",@"资金密码"];
    NSArray *placeholders = @[@"**子",@"请选择收款银行",@"请选择卡片类别",@"请输入银行卡号",@"请选择省份",@"请选择城市",@"请填写具体开户地点",@"6位数数字组合"];
    NSArray *vals = @[[IVNetwork savedUserInfo].realName.length ? [IVNetwork savedUserInfo].realName : @"",@"",@"",@"",@"",@"",@"",@""];
    NSMutableArray *sheetDatas = [NSMutableArray array];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholders[index];
        model.desc = vals[index];
        [sheetDatas addObject:model];
    }
    self.sheetDatas = sheetDatas.mutableCopy;
    [self setupElements];
}

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:captcha forKey:@"captcha"];
    [params setValue:captchaId forKey:@"captchaId"];
    if ([phone containsString:@"*"]) {
        [params setValue:@1 forKey:@"type"];
    } else {
        [params setValue:@0 forKey:@"type"];
    }
    if ([IVNetwork savedUserInfo]) {
        [params setValue:[IVNetwork savedUserInfo].mobileNo forKey:@"mobileNo"];
        [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
    } else {
        [params setValue:phone forKey:@"mobileNo"];
    }
    
    [IVNetwork requestPostWithUrl:BTTCallBackAPI paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self showCallBackSuccessView];
        }else{
            NSString *errInfo = [NSString stringWithFormat:@"申请失败,%@",result.head.errMsg];
            [MBProgressHUD showError:errInfo toView:nil];
        }
    }];
}

- (NSMutableArray *)sheetDatas {
    NSMutableArray *sheetDatas = objc_getAssociatedObject(self, _cmd);
    if (!sheetDatas) {
        sheetDatas = [NSMutableArray array];
        [self setSheetDatas:sheetDatas];
    }
    return sheetDatas;
}

- (void)setSheetDatas:(NSMutableArray *)sheetDatas {
    objc_setAssociatedObject(self, @selector(sheetDatas), sheetDatas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
