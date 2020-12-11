//
//  BTTUsdtTodayNoticeView.h
//  Hybird_1e3c3b
//
//  Created by Levy on 1/15/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTUsdtTodayNoticeView : BTTBaseAnimationPopView

@property (nonatomic, copy) void(^tapCancel)(void);
@property (nonatomic, copy) void(^tapConfirm)(void);
@property (nonatomic, copy) void(^tapContact)(void);

@end

NS_ASSUME_NONNULL_END
