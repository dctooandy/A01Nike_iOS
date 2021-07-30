//
//  BTTUserForzenBGView.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/6.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTUserForzenBGView : UIView
@property (nonatomic, copy) void(^tapToWithdraw)(void);
@property (nonatomic, copy) void(^tapToHome)(void);
+ (instancetype)viewFromXib;
-(void)setupViewController:(UIViewController *)cView;
@end

NS_ASSUME_NONNULL_END
