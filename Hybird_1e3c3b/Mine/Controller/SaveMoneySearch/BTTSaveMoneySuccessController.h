//
//  BTTSaveMoneySuccessController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 03/01/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

typedef enum : NSUInteger {
    BTTSaveMoneyStatusTypeSuccess, ///< 成功
    BTTSaveMoneyStatusTypeFail,    ///< 失败
    BTTSaveMoneyStatusTypeOnGoing,  ///< 处理中
    BTTSaveMoneyStatusTypeCuiSuccess ///< 催单成功
} BTTSaveMoneyStatusType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTSaveMoneySuccessController : BTTCollectionViewController

@property (nonatomic, assign) BTTSaveMoneyStatusType saveMoneyStatus;  ///< 存款状态

@property (nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
