//
//  BTTAddCardController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddCardController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddCardController (LoadData)

- (void)loadMainData;

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId;

@property (nonatomic, strong) NSMutableArray *sheetDatas;

-(void)loadQueryBanks;


@end

NS_ASSUME_NONNULL_END
