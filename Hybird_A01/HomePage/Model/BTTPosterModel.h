//
//  BTTPosterModel.h
//  Hybird_A01
//
//  Created by Domino on 16/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTPosterLogoModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTPosterModel : BTTBaseModel

@property (nonatomic, copy) NSString *link;

@property (nonatomic, strong) BTTPosterLogoModel *logo;

@end

@interface BTTPosterLogoModel : BTTBaseModel

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
