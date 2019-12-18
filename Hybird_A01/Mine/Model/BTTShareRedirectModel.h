//
//  BTTShareRedirectModel.h
//  Hybird_A01
//
//  Created by Domino on 13/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTShareRedirectModel : BTTBaseModel

@property (nonatomic, copy) NSString *domainName;

@property (nonatomic, copy) NSString *redirectUrl;

@end

NS_ASSUME_NONNULL_END
