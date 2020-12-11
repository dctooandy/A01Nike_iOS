//
//  BTTKSAddBfbWalletController.h
//  Hybird_1e3c3b
//
//  Created by Levy on 3/31/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTKSAddBfbWalletController : BTTBaseViewController
@property (nonatomic, copy) void(^success)(NSString *accountNo);

@end

NS_ASSUME_NONNULL_END
