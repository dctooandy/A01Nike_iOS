//
//  BTTLoginOrRegisterViewController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTVideoFastRegisterView.h"
#import "BTTLoginInfoView.h"

typedef enum {
    BTTLoginCellTypeNormal,    // 无码
    BTTLoginCellTypeCode       // 有码
}BTTLoginCellType;



NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginOrRegisterViewController : BTTBaseViewController

@property (nonatomic, assign) BTTRegisterOrLoginType registerOrLoginType;///< 登录注册页面类型

@property (nonatomic, assign) BTTLoginCellType loginCellType;            ///< 登录cell类型

@property (nonatomic, assign) BTTQuickRegisterType qucikRegisterType;    ///< 快速注册类型

@property (nonatomic, strong) UIImage *codeImage;     ///< 图形验证码

@property (nonatomic, assign) NSInteger wrongPwdNum;  ///< 密码错误次数

@property (nonatomic, copy) NSString *uuid; ///< 验证码返回的uuid

@property (nonatomic, copy) NSString *captchaId; ///< 验证码返回的captchaId

@property (nonatomic, copy) NSString *messageId; ///< 验证码的ID

@property (nonatomic, copy) NSString *validateId;

@property (nonatomic, strong) BTTVideoFastRegisterView *fastRegisterView;

@property (nonatomic, strong) BTTLoginInfoView *loginView;

@property (nonatomic, assign) BOOL isWebIn;

@property (nonatomic, strong) NSMutableArray * specifyWordArr;
@property (nonatomic, strong) NSMutableArray * pressLocationArr;
@property (nonatomic, strong) UIImage * imgCodeImg;
@property (nonatomic, copy) NSArray * noticeStrArr;
-(void)removeLocationView;
-(void)checkChineseCaptchaSuccess;
-(void)checkChineseCaptchaAgain;
@end

NS_ASSUME_NONNULL_END
