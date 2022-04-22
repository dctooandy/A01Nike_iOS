//
//  BTTLoginInfoView.h
//  Hybird_1e3c3b
//
//  Created by Levy on 2/18/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginInfoView : UIView
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, copy) void (^sendSmdCode)(NSString *phone);
@property (nonatomic, copy) void (^tapLogin)(NSString *account,NSString *password,BOOL isSmsCode,NSString *codeStr);
@property (nonatomic, copy) void (^tapRegister)(void);
@property (nonatomic, copy) void (^tapForgetAccountAndPwd)(void);
@property (nonatomic, strong)UIView *codeImgView;

@property (nonatomic, copy) NSString *ticketStr;
@property (nonatomic, strong) UIButton *showBtn;

@property (nonatomic, copy) void(^refreshCodeImage)(NSUInteger);
@property (nonatomic, assign) BOOL needCaptcha;     ///< 是否需要图型验证码[1: 是, 0:否]
@property (nonatomic, assign) NSUInteger captchaType; /// 验证码类型[1: 数字验证码; 2:汉字验证码,
@end

NS_ASSUME_NONNULL_END
