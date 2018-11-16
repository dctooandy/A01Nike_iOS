//
//  BTTBindStatusModel.h
//  Hybird_A01
//
//  Created by Domino on 16/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTBindStatusModel : BTTBaseModel

@property (nonatomic, assign) BOOL phone;

@property (nonatomic, assign) BOOL email;

@property (nonatomic, assign) BOOL bank;

@property (nonatomic, assign) BOOL btc;

@end

NS_ASSUME_NONNULL_END
