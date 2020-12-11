//
//  BTTProvinceModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 24/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTCityModel, BTTAreaModel;

NS_ASSUME_NONNULL_BEGIN

/// 省
@interface BTTProvinceModel : BTTBaseModel

/** 省对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 省的名称 */
@property (nonatomic, copy) NSString *name;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;
/** 城市数组 */
@property (nonatomic, strong) NSArray<BTTCityModel *> *citylist;

@end

/// 市
@interface BTTCityModel : BTTBaseModel
/** 市对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 市的名称 */
@property (nonatomic, copy) NSString *name;
/** 市的索引 */
@property (nonatomic, assign) NSInteger index;
/** 地区数组 */
@property (nonatomic, strong) NSArray<BTTAreaModel *> *arealist;

@end

/// 区
@interface BTTAreaModel : BTTBaseModel
/** 区对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 区的名称 */
@property (nonatomic, copy) NSString *name;
/** 区的索引 */
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
