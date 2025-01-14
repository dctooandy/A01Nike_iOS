//
//  BTTBindingMobileController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBindingMobileController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTBindingMobileController (LoadData)

- (void)loadMianData {
    NSString *phoneTitle = nil;
    NSString *phone = @"";
    switch (self.mobileCodeType) {
        case BTTSafeVerifyTypeVerifyMobile:
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileDelBankCard:
        case BTTSafeVerifyTypeMobileAddBTCard:
        case BTTSafeVerifyTypeMobileDelBTCard:
        case BTTSafeVerifyTypeMobileAddUSDTCard:
        case BTTSafeVerifyTypeMobileAddDCBOXCard:
        case BTTSafeVerifyTypeMobileDelUSDTCard:
            phoneTitle = @"已绑定手机";
            phone = [IVNetwork savedUserInfo].mobileNo;
            break;
        case BTTSafeVerifyTypeMobileBindAddBankCard:
        case BTTSafeVerifyTypeMobileBindChangeBankCard:
        case BTTSafeVerifyTypeMobileBindDelBankCard:
        case BTTSafeVerifyTypeMobileBindAddBTCard:
        case BTTSafeVerifyTypeMobileBindDelBTCard:
        case BTTSafeVerifyTypeMobileBindAddUSDTCard:
        case BTTSafeVerifyTypeMobileBindAddDCBOXCard:
        case BTTSafeVerifyTypeMobileBindDelUSDTCard:
        case BTTSafeVerifyTypeBindMobile:
        case BTTSafeVerifyTypeWithdrawPwdBindMobile:{
            phoneTitle = @"手机号码";
            if ([IVNetwork savedUserInfo].mobileNo.length != 0&&[IVNetwork savedUserInfo].mobileNoBind==0) {
                phone = [IVNetwork savedUserInfo].mobileNo;
            }
        }
            break;
        default:
            phoneTitle = @"手机号码";
            break;
    }
    NSArray *names = @[phoneTitle,@"验证码"];
    NSArray *placeholders =@[@"请输入待绑定手机号码",@"请输入验证码"];
    NSArray *vals = @[phone,@""];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholders[index];
        model.desc = vals[index];
        [self.sheetDatas addObject:model];
    }
    [self setupElements];
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
