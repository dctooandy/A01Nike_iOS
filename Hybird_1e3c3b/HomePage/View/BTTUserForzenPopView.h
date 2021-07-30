//
//  BTTUserForzenPopView.h
//  Hybird_1e3c3b
//
//  Created by Andy on 6/29/21.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTUserForzenPopView : BTTBaseAnimationPopView

@property (nonatomic, copy) void(^tapDismiss)(void);
@property (nonatomic, copy) void(^tapActivity)(void);
@property (nonatomic, copy) void(^tapService)(void);
- (void)setuUserForzenContentMessage:(NSNumber *)message;

@end

NS_ASSUME_NONNULL_END
