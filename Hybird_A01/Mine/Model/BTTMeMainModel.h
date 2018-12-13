//
//  BTTMeMainModel.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTMeMainModel : BTTBaseModel

@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) CGFloat cellHeight;
//

@property (nonatomic, copy) NSString *paymentName;

@property (nonatomic, assign) BOOL available;

@property (nonatomic, assign) NSInteger paymentType;

@end

NS_ASSUME_NONNULL_END
