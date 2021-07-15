//
//  BTTVideoFastRegisterView.h
//  Hybird_1e3c3b
//
//  Created by Levy on 2/26/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTVideoFastRegisterView : UIView
@property (nonatomic, strong) UIButton *msgCodeBtn;
- (void)setCodeImage:(UIImage *)codeImg;

@property (nonatomic, copy) void (^sendSmdCode)(NSString *phone);
@property (nonatomic, copy) void(^tapRegister)(NSString *account,NSString *code , NSString *askInputCode);
@property (nonatomic, copy) void(^tapOneKeyRegister)(void);
@property (nonatomic, strong) UITextField *imgCodeField;
@property (nonatomic, strong) UITextField *askInputCodeField;

@end

NS_ASSUME_NONNULL_END
