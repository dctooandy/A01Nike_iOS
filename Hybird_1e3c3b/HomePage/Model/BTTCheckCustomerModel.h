//
//  BTTCheckCustomerModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/16/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTCheckCustomerItemModel;

NS_ASSUME_NONNULL_BEGIN

//        body:{
//            "messageId" : "4b3c934026c44f0b90875d6b07c5e097",
//            "expire" : 0,
//            "loginNames" : [
//                {
//                    "flag" : "1",
//                    "customerLevel" : 6,
//                    "lastLoginDate" : "2021-08-16 13:55:39",
//                    "loginName" : "gtj485960"
//                }
//            ],
//            "validateId" : "3fc043e0fac24129b2387ed05087be42"
//        }

@interface BTTCheckCustomerModel : BTTBaseModel

@property (nonatomic, copy) NSString *messageId;

@property (nonatomic, copy) NSString *expire;

@property (nonatomic, copy) NSString *validateId;

@property (nonatomic, copy) NSArray<BTTCheckCustomerItemModel *> *loginNames;

@end

@interface BTTCheckCustomerItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *customerLevel;

@property (nonatomic, copy) NSString *lastLoginDate;

@property (nonatomic, copy) NSString *loginName;

@end

NS_ASSUME_NONNULL_END
