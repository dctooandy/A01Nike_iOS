//
//  DSBRedBagPopView.h
//  Hybird_1e3c3b
//
//  Created by Levy on 7/30/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSBRedBagPopView : BTTBaseAnimationPopView
@property (nonatomic, copy) void(^tapActivity)(void);
@property (nonatomic, copy) void(^tapConfirm)(void);
- (void)setContentMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
