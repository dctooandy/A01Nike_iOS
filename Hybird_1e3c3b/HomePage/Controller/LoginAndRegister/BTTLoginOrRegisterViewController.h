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
#import "BTTDifferentLocPopView.h"
#import "PuzzleVerifyPopoverView.h"

typedef enum {
    BTTLoginCellTypeNormal,    // 无码
    BTTLoginCellTypeCode       // 有码
}BTTLoginCellType;

// 登录注册验证类型
typedef NS_ENUM(NSUInteger, BTTLoginOrRegisterCaptchaType) {
    BTTLoginOrRegisterCaptchaNone = 0,
    BTTLoginOrRegisterCaptchaDigital = 1,   // 数字验证
    BTTLoginOrRegisterCaptchaChinese = 2,   // 汉字验证
    BTTLoginOrRegisterCaptchaPuzzle  = 3,   // 滑块拼图验证
};

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

@property (nonatomic, copy) NSString *askInputCodeId; ///< 邀请码的ID

@property (nonatomic, copy) NSString *validateId;

@property (nonatomic, copy) NSString *accountStr;

@property (nonatomic, strong) BTTVideoFastRegisterView *fastRegisterView;

@property (nonatomic, strong) BTTLoginInfoView *loginView;

@property (nonatomic, strong) BTTDifferentLocPopView *differentLocPopView;///< 異地登入彈窗
@property (nonatomic, assign) BOOL isDifferentLoc;///< 是否是異地登入
@property (nonatomic, strong) NSMutableDictionary * differentLocResultDict;///< 異地登入返回的body

@property (nonatomic, assign) BOOL isWebIn;

@property (nonatomic, strong) NSMutableArray * pressLocationArr;///< 使用者點擊圖片的座標Array
@property (nonatomic, assign) NSInteger specifyWordNum;///< 漢字驗證碼需要點擊的次數
@property (nonatomic, strong) UIImage * imgCodeImg;///< 漢字驗證碼的圖 3:滑块验证码]
@property (nonatomic, strong, nullable) PuzzleVerifyPopoverView *puzzleView;

-(void)removeLocationView;///< 刪除使用者點擊的座標圖
-(void)checkChineseCaptchaSuccess;///< 漢字驗證成功
-(void)checkChineseCaptchaAgain;///< 重新驗證漢字驗證碼
@end

NS_ASSUME_NONNULL_END
