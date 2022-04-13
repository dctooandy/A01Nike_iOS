//
//  KYMSelectChannelVC.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNMUSDTChannelVC : UIViewController
@property (nonatomic, copy) NSArray *list;
@property (nonatomic, strong) void(^selectedChannelCallback)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
