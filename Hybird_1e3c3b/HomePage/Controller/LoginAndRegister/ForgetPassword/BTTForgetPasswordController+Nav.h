//
//  BTTForgetPasswordController+Nav.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 12/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTForgetPasswordController.h"
#import "JXRegisterManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetPasswordController (Nav)<JXRegisterManagerDelegate>
-(void)setUpNav;
@end

NS_ASSUME_NONNULL_END
