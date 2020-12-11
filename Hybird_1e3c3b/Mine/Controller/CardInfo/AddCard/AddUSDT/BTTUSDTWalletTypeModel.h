//
//  BTTUSDTWalletTypeModel.h
//  Hybird_1e3c3b
//
//  Created by Levy on 3/10/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTUSDTWalletTypeModel : BTTBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray *protocol;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
