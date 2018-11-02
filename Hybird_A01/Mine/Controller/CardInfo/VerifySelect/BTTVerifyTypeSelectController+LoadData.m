//
//  BTTVerifyTypeSelectController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVerifyTypeSelectController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTVerifyTypeSelectController (LoadData)


- (void)loadMainData {
    NSArray *names = @[@"通过短信验证",@"通过人工服务"];
    NSArray *icons = @[@"card_sms",@"card_customer"];
    NSArray *details = @[@"选择此方式, 我们将向您号码为138*****9338的手机发送验证码",@"原绑定手机无法接受验证码? 提交申请, 等待人工客服协助修改"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        model.desc = details[index];
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
