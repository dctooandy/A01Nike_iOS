//
//  BTTGameModel.h
//  Hybird_A01
//
//  Created by Domino on 17/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTGameIconModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTGameModel : BTTBaseModel

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *apiPath;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *params;

@property (nonatomic, strong) BTTGameIconModel *icon;

@property (nonatomic, copy) NSString *gameIcon;

@end

@interface BTTGameIconModel : BTTBaseModel

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
