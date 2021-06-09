//
//  BTTPasswordChangeController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 7/4/2021.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTPasswordChangeController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTPasswordChangeController (LoadData)
- (void)sendCode;
- (void)submitVerifySmsCode;
- (void)submitChange;
@end

NS_ASSUME_NONNULL_END
