//
//  BTTConsetiveWinsPopView.h
//  Hybird_1e3c3b
//
//  Created by Levy on 1/18/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTConsetiveWinsPopView : BTTBaseAnimationPopView

@property (nonatomic, copy) void(^tapActivity)(void);
@property (nonatomic, copy) void(^tapConfirm)(void);
- (void)setContentMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
