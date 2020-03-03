//
//  BTTVideoNormalRegisterView.h
//  Hybird_A01
//
//  Created by Levy on 2/28/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTVideoNormalRegisterView : UIView
@property (nonatomic, copy) void(^tapFast)(void);
@property (nonatomic, copy) void(^tapRegister)(NSString *account,NSString *password);
@end

NS_ASSUME_NONNULL_END
