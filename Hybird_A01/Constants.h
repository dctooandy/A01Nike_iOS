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
#import "IVHttpManager.h"
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
#import "IVNetwork.h"
#import "IVRequestResultModel.h"
#import "BTTHttpManager.h"

typedef enum {
    BTTCanAddCardTypeNone,          // 不能添加任何卡
    BTTCanAddCardTypeAll,           // 银行卡和比特币钱包
    BTTCanAddCardTypeBank,          //  只能添加银行卡
    BTTCanAddCardTypeBTC,           // 只能添加比特币钱包
    BTTCanAddCardTypeUSDT,          // 只能添加USDT
    BTTCanAddCardTypeBankORBTC,     // 添加银行卡或者比特币
    BTTCanAddCardTypeBankORUSDT,    // 添加银行卡或者USDT
    BTTCanAddCardTypeBTCORUSDT,     // 添加USDT或者比特币
}BTTCanAddCardType; // 能添加卡的类型
//typedef enum {
//    BTTEmmailCodeTypeBind,           // 绑定邮箱
//    BTTEmmailCodeTypeVerify,      // 验证邮箱
//    BTTEmmailCodeTypeChange,         // 更换邮箱
//}BTTEmmailCodeType; // 邮箱验证码类型

typedef enum {
    BTTSafeVerifyTypeNormalAddBankCard,          // 添加第一张银行卡
    BTTSafeVerifyTypeNormalAddBTCard,            // 添加第一张比特比钱包
    BTTSafeVerifyTypeNormalAddUSDTCard,
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
    BTTSafeVerifyTypeMobileAddUSDTCard,          // 添加USDT钱包短信验证
    BTTSafeVerifyTypeMobileBindAddBTCard,        // 添加比特币钱包时未绑定手机绑定
    BTTSafeVerifyTypeMobileBindAddUSDTCard,      // 添加USDT钱包时未绑定手机绑定
    BTTSafeVerifyTypeMobileDelBTCard,            // 删除比特币钱包短信验证
    BTTSafeVerifyTypeMobileDelUSDTCard,
    BTTSafeVerifyTypeMobileBindDelBTCard,        // 删除比特币钱包时未绑定手机绑定
    BTTSafeVerifyTypeMobileBindDelUSDTCard,
    BTTSafeVerifyTypeHumanAddBTCard,             // 添加比特币钱包人工服务
    BTTSafeVerifyTypeHumanAddUSDTCard,
    BTTSafeVerifyTypeHumanDelBTCard,             // 删除比特币钱包人工服务
    BTTSafeVerifyTypeHumanDelUSDTCard,
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

typedef void (^CompleteBlock)(IVJResponseObject *response);

typedef void (^BTTLive800ResponseBlock)(NSString *info);

/***********************************************存储关键字******************************************************/



/**********************************************通知常量*******************************************************/

#define BTTShowAccountGride @"BTTShowAccountGride"

#define BTTShareNoticeTag @"BTTShareNoticeTag"

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
#define BTTLoginName        @"loginName"
#define BTTPassword         @"password"
#define BTTTimestamp        @"timestamp"

#define BTTParentID         @"parent_id"
#define BTTPhone            @"phone"

#define BTTSelectedBankId            @"BTTSelectedBankId"
#define BTTCacheBankListKey          @"BTTCacheBankListKey"
#define BTTCacheBTCRateKey           @"BTTCacheBTCRateKey"


/*********************************************API********************************************************/

//app语音未登录回拨
#define BTTVoiceCall        @"_extra_/api/v1/app/public/appCall"
//app语音登录回拨
#define BTTVoiceCallLogin        @"_extra_/api/v1/app/public/appCallByLogin"
// 登录注册
#define BTTUserLoginAPI        @"customer/login"
// 模糊登录
#define BTTUserLoginEXAPI      @"customer/loginEx"
// 生成图片验证
#define BTTVerifyCaptcha       @"captcha/generate"
// 创建账号
#define BTTUserRegister        @"customer/createRealAccount"
// 验证账号信息
#define BTTCheckAccountInfo    @"_extra_/api/v1/ws/check-account-info"
// 验证短信验证码
#define BTTVerifySmsCode       @"phone/verifySmsCode"
// 发送短信验证码
#define BTTSendMsgCode         @"phone/sendCode"
// 根据用户名发送验证码
#define BTTStepOneSendCode     @"phone/sendCodeByLoginName"
// 绑定手机号
#define BTTBindPhone           @"phone/bind"
//忘记密码第一步验证
#define BTTValidateCaptcha     @"customer/preForgetPwd"
// 根据code修改密码
#define BTTStepThreeUpdatePassword @"customer/modifyPwdByCode"
// 根据登录名获取用户信息
#define BTTGetLoginInfoByName  @"customer/getByLoginName"
// 查询400热线
#define BTT400Line             @"queryVIPLine"
// 解锁账号
#define BTTUnlockAccount       @"customer/unlockAccount"
// 修改用户基本信息
#define BTTModifyCustomerInfo         @"customer/modify"
// 查询会员账户接口银行卡和虚拟币
#define BTTAccountQuery        @"account/query"
// 电话回拨API
#define BTTCallBackAPI         @"callback"
// 添加银行卡账号
#define BTTAddBankCard       @"account/create"
// 修改银行卡账号
#define BTTModifyBankCard       @"account/modifyBank"
// 查询会员修改银行卡
#define BTTModifyBankRequests       @"customer/checkPhoneAndBankCard"
// 删除银行卡
#define BTTDeleteBankAccount       @"account/delete"
// 获取USDT钱包下钱包
#define BTTUsdtWallets        @"deposit/queryDepositBankInfos"
// 设置默认取款卡
#define BTTSetDefaultCard        @"account/setDefaultBankCard"
/// 查询存款方式
#define kPaymentValidate       @"deposit/queryPayWaysV3"
// 首页聚合
#define BTTHomePageNewAPI            @"_extra_/api/v1/app/indexCombo"
// 首页banner
#define BTTIndexBannerDownloads      @"_extra_/api/v1/app/banners"
// 首页form
#define BTTBrandHighlights           @"_extra_/api/v1/wms/form"
// 首页公告
#define BTTHomeAnnouncementAPI       @"_extra_/api/v1/other/announcement/common"
// 优惠列表
#define BTTPromotionList             @"_extra_/api/v1/wms/promotions"
// 获取用户额度信息全厅
#define BTTCreditsALL              @"customer/getBalance"
// 金额转账本地接口
#define BTTTransferAllMoneyToLocal   @"game/transferToLocal"
// 转账, 游戏厅转本地 ----NO
#define BTTCreditsTransfer           @"/public/credits/transfer"
// 获取限红额度   ---NO
#define BTTBetLimits                 @"/A01/apply/getBetLimits"
// 申请修改限红   ---NO
#define BTTApplyBetLimit             @"/public/apply/betLimit"
// 短信状态查询  ---NO
#define BTTSmsList                   @"/public/subscription/smsList"
// 邮件状态查询 ----NO
#define BTTEmailList                 @"/public/subscription/emailList"
// 短信状态修改 ----NO
#define BTTSmsOrder                  @"/public/subscription/smsOrder"
// 邮件状态修改  ---NO
#define BTTEmailOrder                @"/public/subscription/emailOrder"
// 开户礼金和存款礼金即可欧 ---NO
#define BTTOpenAccountStatus         @"/A01/openAccount/isOpen"
// 请求游戏列表
#define BTTVideoGamesList            @"_extra_/api/v1/wms/game"
// 获取收藏列表
#define BTTFavotiteList              @"_extra_/api/v1/wms/gameFavorList"
// 添加收藏
#define BTTAddFavotites              @"_extra_/api/v1/wms/gameFavor"
// 搏币数量查询
#define BTTQueryIntegralAPI          @"_extra_/api/v1/activity/luckyWheel/myLeftPrize"
// 搏币兑换
#define BTTCoinDepositAPI            @"_extra_/api/v1/activity/luckyWheel/depositPrize"
// 请求未读消息的数量
#define BTTIsUnviewedAPI             @"letter/countUnread"
// 人工存款信息错误重新提交---NO
#define BTTDepositResubmmitAPI       @"/A01/payment/reSubmitDepositRequestEndpoint"
// 迅捷存款信息错误重新提交---NO
#define BTTBQAddOrderAPI             @"/A01/payment/BQAddOrder"
// 手工存款催单 ---NO
#define BTTCreditAppealAPI           @"/A01/payment/createCreditAppeal"
// 迅捷, 在线催款催单接口---NO
#define BTTAreditAppealAPI           @"/A01/payment/createAreditAppeal"
// 客户存款次数的接口
#define BTTSaveMoneyTimesAPI         @"_extra_/api/v1/app/deposit/getIsDepositAmount"
// 查询可分享链接
#define BTTGetWeiXinRediect          @"_extra_/api/v1/app/public/getWeiXinRedirect"
// 查询存款金额列表
#define BTTQueryAmountList           @"deposit/queryAmountList"
// 查询洗码额度v2
#define BTTXimaAmount                @"xm/calcAmountV2"
// 查询洗码提案列表
#define BTTXimaQueryRequest          @"xm/queryRequest"
// 查询洗码历史记录
#define BTTXiMaHistoryListUrl        @"_extra_/api/v1/getBetAmountByDay"
// 查询BQ存款银行
#define BTTQueryBQBankList           @"deposit/queryBQBanks"
// 查询USDT汇率
#define BTTCurrencyExchanged         @"deposit/currencyExchange"
// USDT手工支付存款
#define BTTManualPay                 @"deposit/createManualDepositRequest"
// 查询在线支付银行列表
#define BTTQueryOnlineBanks          @"deposit/queryOnlineBanks"
// 创建在线支付订单
#define BTTCreateOnlineOrder         @"deposit/createOnlineOrder"
// 查询人工存款账号
#define BTTQueryManualAccount        @"deposit/queryManualDepositAccount"

#define BTTCreditsGame               @"/public/credits/game"
#define BTTCreditsTotalAvailable     @"/public/credits/totalAvailable"
#define BTTIsBindStatusAPI           @"/public/verify/isNewBind"
#define BTTGamePlatforms             @"/A01/game/platforms"

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
