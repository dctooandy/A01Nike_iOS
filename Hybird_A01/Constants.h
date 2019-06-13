//
//  Constants.h
//  A01_Sports
//
//  Created by Domino on 2018/9/21.
//  Copyright © 2018年 BTT. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#import "BTTBaseViewController.h"
#import "BTTBaseNavigationController.h"
#import "BTTTabbarController.h"
#import "NSDate+Extension.h"
#import "UIColor+Util.h"
#import "UIView+Frame.h"
#import <IVNetworkLibrary/IVNetwork.h>
#import <IVGameLibrary/IVGame.h>
#import "PublicMethod.h"
#import <GJRedDot/GJRedDot.h>
#import "BTTRedDotManager.h"
#import "NSString+Expand.h"
#import "BridgeModel.h"
#import "WebConfigModel.h"
#import "HAConstant.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "BTTBaseWebViewController.h"
#import "BTTAnimationPopView.h"
#import <IN3SAnalytics/IN3SAnalytics.h>
#import "CNTimeLog.h"

typedef enum {
    BTTCanAddCardTypeNone,          // 不能添加任何卡
    BTTCanAddCardTypeAll,           // 银行卡和比特币钱包
    BTTCanAddCardTypeBank,          //  只能添加银行卡
    BTTCanAddCardTypeBTC,           // 只能添加比特币钱包
}BTTCanAddCardType; // 能添加卡的类型
//typedef enum {
//    BTTEmmailCodeTypeBind,           // 绑定邮箱
//    BTTEmmailCodeTypeVerify,      // 验证邮箱
//    BTTEmmailCodeTypeChange,         // 更换邮箱
//}BTTEmmailCodeType; // 邮箱验证码类型

typedef enum {
    BTTSafeVerifyTypeNormalAddBankCard,          // 添加第一张银行卡
    BTTSafeVerifyTypeNormalAddBTCard,            // 添加第一张比特比钱包
    BTTSafeVerifyTypeMobileAddBankCard,          // 添加银行卡短信验证
    BTTSafeVerifyTypeMobileBindAddBankCard,      // 添加银行卡时未绑定手机绑定
    BTTSafeVerifyTypeMobileChangeBankCard,       // 修改银行卡短信验证
    BTTSafeVerifyTypeMobileBindChangeBankCard,   // 修改银行卡时未绑定手机绑定
    BTTSafeVerifyTypeMobileDelBankCard,          // 删除银行卡短信验证
    BTTSafeVerifyTypeMobileBindDelBankCard,      // 删除银行卡时未绑定手机绑定
    BTTSafeVerifyTypeHumanAddBankCard,           // 添加银行卡人工服务
    BTTSafeVerifyTypeHumanChangeBankCard,        // 修改银行卡人工服务
    BTTSafeVerifyTypeHumanDelBankCard,           // 删除银行卡人工服务
    BTTSafeVerifyTypeMobileAddBTCard,            // 添加比特币钱包短信验证
    BTTSafeVerifyTypeMobileBindAddBTCard,        // 添加比特币钱包时未绑定手机绑定
    BTTSafeVerifyTypeMobileDelBTCard,            // 删除比特币钱包短信验证
    BTTSafeVerifyTypeMobileBindDelBTCard,        // 删除比特币钱包时未绑定手机绑定
    BTTSafeVerifyTypeHumanAddBTCard,             // 添加比特币钱包人工服务
    BTTSafeVerifyTypeHumanDelBTCard,             // 删除比特币钱包人工服务
    BTTSafeVerifyTypeChangeMobile,               // 更改手机号
    BTTSafeVerifyTypeBindMobile,                 // 绑定手机号
    BTTSafeVerifyTypeVerifyMobile,               // 验证手机号
    BTTSafeVerifyTypeHumanChangeMoblie,          // 更改手机号人工服务
    BTTSafeVerifyTypeBindEmail,                  // 绑定邮箱
    BTTSafeVerifyTypeVerifyEmail,                // 验证邮箱
    BTTSafeVerifyTypeChangeEmail,                // 更改邮箱
}BTTSafeVerifyType; // 安全验证种类
typedef enum {
    BTTRegisterOrLoginTypeLogin,
    BTTRegisterOrLoginTypeRegisterNormal, // 普通开户
    BTTRegisterOrLoginTypeRegisterQuick  // 极速开户
    
}BTTRegisterOrLoginType;

typedef enum {
    BTTQuickRegisterTypeAuto,   // 自动
    BTTQuickRegisterTypeManual  // 手动
}BTTQuickRegisterType;

typedef enum {
    BTTStringFormatStyleNum = 1, ///< 全数字字符串
    BTTStringFormatStyleChar,    ///< 全字母
    BTTStringFormatStyleCharAndNum, ///< 数字和字母混合
    BTTStringFormatStyleOther    ///< 包含特殊符号
}BTTStringFormatStyle;

typedef void (^CompleteBlock)(IVRequestResultModel *result, id response);

/***********************************************存储关键字******************************************************/



/**********************************************通知常量*******************************************************/

//Flurry
#define FlurryKey  @"RY7GPP2V792PMZK3PYNX"

//live800相关
#define Live800SkillId  @"10"

#define BTTBannerDefaultWidth  1280
#define BTTBnnnerDefaultHeight 440

#define BTTNavHeightNotLogin (KIsiPhoneX ? (88 + 49) : 113)
#define BTTNavHeightLogin    (KIsiPhoneX ? 88 : 64)

//听云相关
#define TingYunAppId  @"402c4df0e9124425ba0b2feb76d120b0"

// VOIP
#define BTTVoiceCallNumKey @"BTTVoiceCallNumKey"

#define BTTUIDKey          @"BTTUIDKey"

#define BTTVoiceCallResetTabbar  @"BTTVoiceCallResetTabbar"

#define BTTWelcomePage     @"BTTWelcomePage"
#define BTTLaunchScreenTime 3

#define BTTUnreadMessageNumKey      @"BTTUnreadMessageNumKey"

#define BTTVerisionUpdateKey        @"BTTVerisionUpdateKey"

// 存款超过十次的用户

#define BTTSaveMoneyMoreThenTenKey     @"BTTSaveMoneyMoreThenTenKey"


// 客户存款次数key

#define BTTSaveMoneyTimesKey          @"BTTSaveMoneyTimesKey"

// 客户存款次数通知

#define BTTSaveMoneyTimesNotification    @"BTTSaveMoneyTimesNotification"

// 验证码发送按钮控制通知

#define BTTVerifyCodeEnableNotification @"BTTVerifyCodeEnableNotification"
#define BTTVerifyCodeDisableNotification @"BTTVerifyCodeDisableNotification"
#define BTTVerifyCodeSendNotification    @"BTTVerifyCodeSendNotification"

// PublicBtnCell按钮通知
#define BTTPublicBtnEnableNotification  @"BTTPublicBtnEnableNotification"
#define BTTPublicBtnDisableNotification  @"BTTPublicBtnDisableNotification"

// 注册成功页面通知: 1. 首页. 2. 个人中心

#define BTTRegisterSuccessGotoHomePageNotification  @"BTTRegisterSuccessGotoHomePageNotification"
#define BTTRegisterSuccessGotoMineNotification      @"BTTRegisterSuccessGotoMineNotification"

//状态栏样式
#define StatusBarStyle UIStatusBarStyleLightContent

// 小红点常量宏

// 主页
#define BTTHomePage         @"HomePage"
#define BTTHomePageItemsKey @"HomePageItemsKey"
#define BTTHomePageMessage  @"HomePageMessage"

#define BTTDiscount         @"Discount"
#define BTTDiscountItemsKey @"DiscountItemsKey"
#define BTTDiscountMessage  @"DiscountMessage"

// 个人中心
#define BTTMineCenter           @"MineCenter"
#define BTTMineCenterItemsKey   @"MineCenterItemsKey"
#define BTTMineCenterMessage    @"MineCenterMessage"
#define BTTMineCenterVersion    @"MineCenterVersion"
#define BTTMineCenterNavMessage @"MineCenterNavMessage"


// 账号缓存key

#define BTTCacheAccountName   @"BTTCacheAccountName"

#define BTTCoinTimestamp       @"BTTCoinTimestamp"

// 

// 昵称缓存字段
#define BTTNicknameCache      @"BTTNicknameCache"


/*********************************************API********************************************************/

#define BTTVoiceCall        @"/A01/phones/appCall"
#define BTTVoiceCallLogin        @"/A01/phones/appCallByLogin"

// 登录注册

#define BTTLoginName        @"login_name"
#define BTTPassword         @"password"
#define BTTTimestamp        @"timestamp"

#define BTTParentID         @"parent_id"
#define BTTPhone            @"phone"

#define BTTUserLoginAPI        @"/public/users/login"
#define BTTUserCreateAPI       @"/A01/users/create"
#define BTTVerifyCaptcha       @"/public/otherVerify/captcha"
#define BTTUserFastRegister    @"/A01/users/fastRegister"
#define BTTNoLoginMobileCodeAPI @"/public/otherVerify/send"
#define BTTStepOneSendCode     @"/A01/forgot/stepOneSendCode"
#define BTTValidateCaptcha     @"/public/otherVerify/validateCaptcha"
#define BTTStepTwoCheckCode    @"/public/forgot/stepTwoCheckCode"
#define BTTStepThreeUpdatePassword @"/public/forgot/stepThreeUpdatePassword"
#define BTTUnlockAccount       @"/A01/users/unlockAccount"
#define BTTGetCustromerByPhone @"/public/users/getCustomersByPhone"

#define BTTSuperFastRegister   @"/A01/users/superFastRegister"
#define BTTSetNickname         @"/A01/users/setNickName"
#define BTTGetMyAlias          @"/A01/users/getMyAlias"
#define BTTPromotionStatus     @"/A01/promotion/status"


// 电话回拨API
#define BTTCallBackMemberAPI         @"/public/phones/memberCall"
#define BTTCallBackCustomAPI         @"/public/phones/customCall"

// 本地额度 + 最后一厅额度

#define BTTCreditsTotalAvailable     @"/public/credits/totalAvailable"

// 查询账号绑定状态

#define BTTIsBindStatusAPI           @"/public/verify/isNewBind"

// 首页逻辑接口

#define BTTHomePageNewAPI            @"/A01/promotion/indexCombo"
#define BTTIndexBannerDownloads      @"/A01/promotion/indexBannerDownloads"
#define BTTBrandHighlights           @"/A01/promotion/getBrandHighlights"


// 优惠列表

#define BTTPromotionList             @"/A01/promotion/newList"

// 获取用户本地额度

#define BTTCreditsLocal              @"/public/credits/local"

//取款是否需要流水
#define BTTBetInfo                   @"/A01/bet/betInfo"

#define BTTSelectedBankId            @"BTTSelectedBankId"
#define BTTCacheBankListKey          @"BTTCacheBankListKey"
#define BTTCacheBTCRateKey           @"BTTCacheBTCRateKey"
// 获取游戏大厅列表

#define BTTGamePlatforms             @"/A01/game/platforms"

// 用户单个厅余额查询

#define BTTCreditsGame               @"/public/credits/game"

// 金额转账本地接口

#define BTTTransferAllMoneyToLocal   @"/public/credits/transferAllMoneyToLocal"

// 转账, 游戏厅转本地

#define BTTCreditsTransfer           @"/public/credits/transfer"

// 获取当前可以洗码的k列表

#define BTTXmCurrentList             @"/A01/xm/currentList"

// 获取洗码历史列表

#define BTTXmHistoryList             @"/A01/xm/historyList"

// 获取限红额度

#define BTTBetLimits                 @"/A01/apply/getBetLimits"

// 申请修改限红
#define BTTApplyBetLimit             @"/public/apply/betLimit"

// 短信状态查询

#define BTTSmsList                   @"/public/subscription/smsList"

// 邮件状态查询

#define BTTEmailList                 @"/public/subscription/emailList"

// 短信状态修改

#define BTTSmsOrder                  @"/public/subscription/smsOrder"

// 邮件状态修改

#define BTTEmailOrder                @"/public/subscription/emailOrder"

// 洗码接口

#define BTTXimaBillOut               @"/public/xm/billout"

// 开户礼金和存款礼金即可欧

#define BTTOpenAccountStatus         @"/A01/openAccount/isOpen"

// 请求游戏列表

#define BTTVideoGamesList            @"/A01/game/slotGameSupportPage"

// 获取收藏列表

#define BTTFavotiteList              @"/A01/game/getFavoriteList"

// 添加收藏

#define BTTAddFavotites              @"/public/game/addFavorites"

// 取消收藏

#define BTTCancelFavorites           @"/public/game/cancelFavorites"

// 搏币数量查询
#define BTTQueryIntegralAPI          @"/A01/luckyWheel/queryIntegral"

// 搏币兑换
#define BTTCoinDepositAPI            @"/A01/luckyWheel/deposit"

// 请求未读消息的数量
#define BTTIsUnviewedAPI             @"/public/letter/isUnviewed"

// 人工存款信息错误重新提交
#define BTTDepositResubmmitAPI       @"/A01/payment/reSubmitDepositRequestEndpoint"

// 迅捷存款信息错误重新提交
#define BTTBQAddOrderAPI             @"/A01/payment/BQAddOrder"

// 手工存款催单
#define BTTCreditAppealAPI           @"/A01/payment/createCreditAppeal"

// 迅捷, 在线催款催单接口
#define BTTAreditAppealAPI           @"/A01/payment/createAreditAppeal"

// 客户存款次数的接口

#define BTTSaveMoneyTimesAPI         @"/deposit/getIsDepositAmount"

/********************************************常用宏*********************************************************/

#define kFontSystem(X)  ([UIFont systemFontOfSize:X])
#define kFontWeightLight(X) ([UIFont systemFontOfSize:X weight:UIFontWeightLight])
#define kFontSystemBold(X) ([UIFont boldSystemFontOfSize:X])
#define kFontMedium(X) ([UIFont fontWithName:@"STHeitiSC-Medium" size:X])
#define kFontLight(X) ([UIFont fontWithName:@"STHeitiSC-Light" size:X])
#define kFontArialMT(X) ([UIFont fontWithName:@"ArialMT" size:X])

// app_version版本号
#define app_version   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define build_version   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

//沙盒中web资源目录
#define WebAppPath   [NSString stringWithFormat:@"%@/webApp",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
//沙盒中热更资源目录
#define HotAppPath   [NSString stringWithFormat:@"%@/hotApp",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
//沙盒中h5增量更新资源目录
#define ZLAppPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"zl.zip"]
#define LocalHtmlPath(url) [NSString stringWithFormat:@"%@/__html/%@",WebAppPath,url]

//带有RGBA的颜色设置
#define COLOR_RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//定义UIImage对象
#define ImageNamed(A) [UIImage imageNamed:A]

// 定义弱引用
#define weakSelf(weakSelf) __weak __typeof(&*self) weakSelf = self;
#define strongSelf(strongSelf) __strong __typeof(&*weakSelf)strongSelf = weakSelf;


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// tabbar 适配iPhone X
#define kTabbarHeight (KIsiPhoneX ? (BTTDangerousAreaH + 49) : 49)
// 是否为iPhoneX
#define KIsiPhoneX (((int)((SCREEN_HEIGHT / SCREEN_WIDTH) * 100) == 216) ? YES : NO)
#define BTTDangerousAreaH 34

//导航栏title样式
#define NavigationBarTitleTextAttributes [NSDictionary dictionaryWithObjectsAndKeys:\
[UIColor whiteColor], NSForegroundColorAttributeName,\
kFontSystem(17.0),    NSFontAttributeName,\
nil]

// 判断obj是否为空
#define A01IsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//主题
#define App_Theme [NSDictionary dictionaryWithObjectsAndKeys:\
[UIColor whiteColor],      NSForegroundColorAttributeName,\
COLOR_RGBA(42, 45, 53, 1), NSBackgroundColorAttributeName,\
[UIColor whiteColor],      NSLaunchTitleColorAttributeName,\
nil]


//----------------------单例---------------------------
#define SingletonInterface(Class) \
+ (Class *)sharedInstance;


#define SingletonImplementation(Class) \
static Class *__ ## sharedSingleton; \
\
\
+ (void)initialize \
{ \
static BOOL initialized = NO; \
if(!initialized) \
{ \
initialized = YES; \
__ ## sharedSingleton = [[Class alloc] init]; \
} \
} \
\
\
+ (Class *)sharedInstance \
{ \
return __ ## sharedSingleton; \
} \
\


//----------防止在主线程调用dispatch_main出现同步锁死----
#define dispatch_main_sync_safe(block){\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}}
//----------防止在主线程调用dispatch_main出现异步问题----
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

//Alert
#define SHOWALERT(title, msg, cancel) do{ \
UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil]; \
[alertview show]; }while(0)

#endif

#ifndef isDictWithCountMoreThan0

#define isDictWithCountMoreThan0(__dict__) \
(__dict__!=nil && \
[__dict__ isKindOfClass:[NSDictionary class] ] && \
__dict__.count>0)

#endif

#ifndef isArrayWithCountMoreThan0

#define isArrayWithCountMoreThan0(__array__) \
(__array__!=nil && \
[__array__ isKindOfClass:[NSArray class] ] && \
__array__.count>0)


#endif /* Constants_h */
