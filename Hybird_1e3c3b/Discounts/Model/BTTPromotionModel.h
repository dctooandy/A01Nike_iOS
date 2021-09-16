//
//  BTTPromotionModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 17/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTPromotionProcessModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTPromotionModel : BTTBaseModel

@property (nonatomic, copy) NSArray<BTTPromotionProcessModel *> *process;

@property (nonatomic, copy) NSDictionary *history;

@end

@interface BTTPromotionProcessModel : BTTBaseModel
@property (nonatomic, copy) NSString *retain4;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *retain1;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, copy) NSString *time_begin;
@property (nonatomic, copy) NSString *time_end;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *retain3;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *retain2;
@property (nonatomic, copy) NSString *is_blank;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic2;
@end

NS_ASSUME_NONNULL_END
