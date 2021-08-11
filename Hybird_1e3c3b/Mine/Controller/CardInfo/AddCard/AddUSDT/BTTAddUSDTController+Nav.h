//
//  BTTAddUSDTController+Nav.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/11/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTAddUSDTController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddUSDTController (Nav)
- (void)showCallBackViewLogin;
- (void)showCallBackViewNoLogin:(BTTAnimationPopStyle)animationPopStyle;
- (void)showCallBackSuccessView;
- (void)showCantBindCardPopView;
@end

NS_ASSUME_NONNULL_END
