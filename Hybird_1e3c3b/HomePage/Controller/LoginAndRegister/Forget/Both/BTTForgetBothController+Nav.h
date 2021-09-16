//
//  BTTForgetBothController+Nav.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/17/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetBothController.h"
#import "JXRegisterManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetBothController (Nav)<JXRegisterManagerDelegate>
-(void)setUpNav;
@end

NS_ASSUME_NONNULL_END
