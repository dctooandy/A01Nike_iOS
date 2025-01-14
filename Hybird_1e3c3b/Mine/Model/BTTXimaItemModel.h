//
//  BTTXimaItemModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTXimaItemModel;
@class BTTXimaItemTypesModel;
@class BTTXimaLastWeekItemModel;

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

@property (nonatomic, assign) double betAmount;

@property (nonatomic, assign) NSInteger remBetAmount;

@property (nonatomic, assign) NSInteger sortNo;

@property (nonatomic, assign) double totalBetAmont;

@property (nonatomic, assign) double xmAmount;

@property (nonatomic, copy) NSString *xmRate;

@property (nonatomic, copy) NSString *multiBetRate;

@property (nonatomic, strong) NSArray <BTTXimaItemTypesModel *> *xmTypes;

@end

@interface BTTXimaItemTypesModel : BTTBaseModel

@property (nonatomic, copy) NSString *xmType;

@property (nonatomic, copy) NSString *betAmount;

@property (nonatomic, copy) NSString *totalBetAmont;

@property (nonatomic, copy) NSString *xmAmount;

@property (nonatomic, copy) NSString *xmRate;

@end

@interface BTTXimaLastWeekItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *auditDate;
@property (nonatomic, copy) NSString *bettingAmount;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *flagDesc;
@property (nonatomic, copy) NSString *gameKindName;
@property (nonatomic, copy) NSString *platformName;
@property (nonatomic, copy) NSString *rate;

@end

NS_ASSUME_NONNULL_END
