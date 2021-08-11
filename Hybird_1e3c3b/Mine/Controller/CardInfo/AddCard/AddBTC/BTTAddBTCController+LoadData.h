//
//  BTTAddBTCController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddBTCController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddBTCController (LoadData)

- (void)loadMainData;

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId;

@property (nonatomic, strong) NSMutableArray *sheetDatas;

@end

NS_ASSUME_NONNULL_END
