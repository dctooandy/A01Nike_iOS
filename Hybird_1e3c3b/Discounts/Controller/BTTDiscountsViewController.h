//
//  BTTDiscountsViewController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "JXRegisterManager.h"

typedef enum {
    BTTDiscountsVCTypeFirst, ///< 首页
    BTTDiscountsVCTypeDetail ///< 详情页
}BTTDiscountsVCType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTDiscountsViewController : BTTCollectionViewController<JXRegisterManagerDelegate>

@property (nonatomic, assign) BTTDiscountsVCType discountsVCType;

@end

NS_ASSUME_NONNULL_END
