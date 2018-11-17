//
//  BTTHomePageViewController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageViewController (LoadData)

@property (nonatomic, strong) NSMutableArray *imageUrls;

@property (nonatomic, copy) NSString *noticeStr;

@property (nonatomic, strong) NSMutableArray *headers;

@property (nonatomic, strong) NSMutableArray *Activities;

@property (nonatomic, strong) NSMutableArray *amounts;

@property (nonatomic, assign) NSInteger nextGroup;


#pragma mark 加载所有数据
- (void)loadDataOfHomePage;

- (void)makeCallWithPhoneNum:(NSString *)phone;

- (void)loadMainData;

@end

NS_ASSUME_NONNULL_END
