//
//  BTTSubcribModel.h
//  Hybird_A01
//
//  Created by Levy on 1/15/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTSubcribModel : BTTBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger subscribed;

@end

NS_ASSUME_NONNULL_END
