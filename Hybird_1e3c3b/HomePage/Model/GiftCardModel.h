//
//  GiftCardModel.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiftCardModel : BTTBaseModel
@property (nonatomic, copy) NSString *cardCode;//福卡code
@property (nonatomic, copy) NSString *cardName;//福卡名称
@property (nonatomic, copy) NSString *count;//数量

@end

NS_ASSUME_NONNULL_END
