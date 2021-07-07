//
//  BTTLockButtonView.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/7.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTLockButtonView : UIView
@property (nonatomic, copy) void(^tapLock)(void);
+ (instancetype)viewFromXib;
@end

NS_ASSUME_NONNULL_END
