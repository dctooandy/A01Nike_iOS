//
//  BTTXimaItemModel.h
//  Hybird_A01
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTXimaItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface BTTXimaTotalModel : BTTBaseModel

@property (nonatomic, strong) NSArray <BTTXimaItemModel *> *list;

@property (nonatomic, copy) NSString *totalAmount;

@end

@interface BTTXimaItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *currBet;

@property (nonatomic, copy) NSString *rate;

@property (nonatomic, copy) NSString *totalBet;

@property (nonatomic, copy) NSString *validAmount;

@property (nonatomic, copy) NSString *xm_type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
