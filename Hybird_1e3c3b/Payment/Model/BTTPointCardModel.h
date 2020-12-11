//
//  BTTPointCardModel.h
//  Hybird_1e3c3b
//
//  Created by Levy on 2/13/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTPointCardListModel : BTTBaseModel
@property (nonatomic, copy) NSString *cardNum;
@property (nonatomic, copy) NSString *channelCode;
@property (nonatomic, copy) NSString *payid;
@property (nonatomic, strong) NSArray *pointCardList;
@end

@interface BTTPointCardModel : BTTBaseModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, strong) NSArray *cardValues;
@property (nonatomic, copy) NSString *values;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@end

NS_ASSUME_NONNULL_END
