//
//  KYMWithdrawAlertVC.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/3/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrawAlertVC : UIViewController
@property (nonatomic,strong) void(^(confirmBtnHandler))(void);
@property (nonatomic,strong) void(^(noConfirmBtnHandler))(void);
@end

NS_ASSUME_NONNULL_END
