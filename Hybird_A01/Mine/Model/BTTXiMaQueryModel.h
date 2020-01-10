//
//  BTTXiMaQueryModel.h
//  Hybird_A01
//
//  Created by Levy on 1/10/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTXiMaQueryModel : BTTBaseModel

@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, copy) NSString *auditDate;

@property (nonatomic, assign) NSInteger bettingAmount;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) BOOL deleteFlag;

@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, copy) NSString *flagDesc;

@property (nonatomic, copy) NSString *gameKind;

@property (nonatomic, copy) NSString *gameKindName;

@property (nonatomic, copy) NSString *itemIcon;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *platform;

@property (nonatomic, copy) NSString *platformname;

@property (nonatomic, copy) NSString *rate;

@property (nonatomic, copy) NSString *rebateModel;

@property (nonatomic, copy) NSString *requestId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *updateDate;

@end

NS_ASSUME_NONNULL_END
