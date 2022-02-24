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
#import "KYMWithdrewFaildVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface KYMFastWithdrewVC : BTTBaseViewController
@property (nonatomic, strong) KYMGetWithdrewDetailModel *detailModel;
//@property (nonatomic, strong) id getDetailParams;
@property (nonatomic, strong) NSString *mmProcessingOrderTransactionId;
@end

NS_ASSUME_NONNULL_END
