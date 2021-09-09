//
//  BTTVIPClubPageViewController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/4.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPClubPageViewController.h"
#import "VIPHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTTVIPClubPageViewController (LoadData)
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, assign) NSInteger nextGroup;
#pragma mark 加载所有数据
- (void)loadDataOfVIPClubPage;
- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId ;
- (VIPHistoryModel *)createVIPHistoryData;
@end

NS_ASSUME_NONNULL_END
