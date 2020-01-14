//
//  BTTMeMainModel.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
#import "CNPaymentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTMeMainModel : BTTBaseModel

@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) CGFloat cellHeight;
//

@property (nonatomic, copy) NSString *paymentName;

@property (nonatomic, assign) BOOL available;

@property (nonatomic, assign) NSInteger paymentType;

@property (nonatomic, assign) BOOL isError; ///< 是否是错误字段

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, strong) CNPaymentModel *payModel;

@property (nonatomic, strong) NSArray<CNPaymentModel *> *payModels;

@end

NS_ASSUME_NONNULL_END
