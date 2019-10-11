//
//  BTTXimaRecordModel.h
//  Hybird_A01
//
//  Created by Domino on 10/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTXimaRecordItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTXimaRecordModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, strong) NSArray<BTTXimaRecordItemModel *> *list;

@end

@interface BTTXimaRecordItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *date;

@end

NS_ASSUME_NONNULL_END
