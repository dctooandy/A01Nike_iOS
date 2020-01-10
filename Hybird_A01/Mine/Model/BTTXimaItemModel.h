//
//  BTTXimaItemModel.h
//  Hybird_A01
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTXimaItemModel;
@class BTTXimaItemTypesModel;

NS_ASSUME_NONNULL_BEGIN


@interface BTTXimaTotalModel : BTTBaseModel

@property (nonatomic, strong) NSArray <BTTXimaItemModel *> *xmList;

@property (nonatomic, assign) NSInteger totalXmAmount;

@property (nonatomic, assign) NSInteger minBetAmount;

@property (nonatomic, assign) NSInteger minXmAmount;

@property (nonatomic, assign) NSInteger totalBetAmount;

@property (nonatomic, copy) NSString *xmBeginDate;

@property (nonatomic, copy) NSString *xmEndDate;

@end

@interface BTTXimaItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *gameKind;

@property (nonatomic, copy) NSString *platformId;

@property (nonatomic, copy) NSString *promotionId;

@property (nonatomic, copy) NSString *xmId;

@property (nonatomic, copy) NSString *xmName;

@property (nonatomic, copy) NSString *xmType;

@property (nonatomic, assign) NSInteger betAmount;

@property (nonatomic, assign) NSInteger remBetAmount;

@property (nonatomic, assign) NSInteger sortNo;

@property (nonatomic, assign) NSInteger totalBetAmont;

@property (nonatomic, assign) NSInteger xmAmount;

@property (nonatomic, copy) NSString *xmRate;

@property (nonatomic, strong) NSArray <BTTXimaItemTypesModel *> *xmTypes;

@end

@interface BTTXimaItemTypesModel : BTTBaseModel

@property (nonatomic, copy) NSString *xmType;

@property (nonatomic, assign) NSInteger betAmount;

@property (nonatomic, assign) NSInteger totalBetAmont;

@property (nonatomic, assign) NSInteger xmAmount;

@property (nonatomic, assign) NSInteger xmRate;

@end

NS_ASSUME_NONNULL_END
