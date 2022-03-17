//
//  KYMFastWithdrewVC.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYMGetWithdrewDetailModel.h"
#import "BTTBaseViewController.h"
#import "KYMWithdrewSuccessVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface KYMFastWithdrewVC : BTTBaseViewController
@property (nonatomic, strong) KYMGetWithdrewDetailModel *detailModel;
@property (nonatomic, strong) NSString *mmProcessingOrderTransactionId;
- (void)stopTimer;
@property (nonatomic, assign) BOOL backToLastVC;
@end

NS_ASSUME_NONNULL_END
