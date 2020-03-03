//
//  BTTVideoFastRegisterView.h
//  Hybird_A01
//
//  Created by Levy on 2/26/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTVideoFastRegisterView : UIView
@property (nonatomic, strong) UIButton *imgCodeBtn;
- (void)setCodeImage:(UIImage *)codeImg;

@property (nonatomic, copy) void(^refreshCodeImage)(void);
@property (nonatomic, copy) void(^tapRegister)(NSString *account,NSString *code);
@property (nonatomic, copy) void(^tapNormalRegister)(void);

@end

NS_ASSUME_NONNULL_END
