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
#import <IN3SAnalytics/CNTimeLog.h>
#import "IVNetwork.h"
#import "IVRequestResultModel.h"
#import "BTTHttpManager.h"
#import "BGFMDB.h"
#import "IVUtility.h"
#import "IVRsaEncryptWrapper.h"
#import "BTTActionSheet.h"
#import "LiveChat.h"
#import "BTTUserStatusManager.h"

typedef enum {
    BTTCanAddCardTypeNone,          // 不能添加任何卡
    BTTCanAddCardTypeAll,           // 银行卡和比特币钱包
    BTTCanAddCardTypeBank,          // 只能添加银行卡
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
    BTTSafeVerifyTypeMobileAddDCBOXCard,
    BTTSafeVerifyTypeMobileBindAddBTCard,        // 添加比特币钱包时未绑定手机绑定
    BTTSafeVerifyTypeMobileBindAddUSDTCard,      // 添加USDT钱包时未绑定手机绑定
    BTTSafeVerifyTypeMobileBindAddDCBOXCard,
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
    BTTSafeVerifyTypeWithdrawPwdBindMobile,      // 新增資金密碼時綁定手機
    BTTSafeVerifyTypeVerifyMobile,               // 验证手机号
    BTTSafeVerifyTypeHumanChangeMoblie,          // 更改手机号人工服务
    BTTSafeVerifyTypeBindEmail,                  // 绑定邮箱
    BTTSafeVerifyTypeVerifyEmail,                // 验证邮箱
    BTTSafeVerifyTypeChangeEmail,                // 更改邮箱
}BTTSafeVerifyType; // 安全验证种类

typedef enum : NSUInteger {
    BTTChangeLoginPwd = 0,
    BTTChangeWithdrawPwd = 1,
    BTTChangePTPwd = 2,
} BTTChangePasswordType;

typedef enum : NSUInteger {
    BTTMeSaveMoneyShowTypeAll = 0,
    BTTMeSaveMoneyShowTypeBig = 1,
    BTTMeSaveMoneyShowTypeMore = 2,
    BTTMeSaveMoneyShowTypeBigOneMore,  // 只有一行大, 一行more
    BTTMeSaveMoneyShowTypeTwoMore,     // 两行more
    BTTMeSaveMoneyShowTypeNone
} BTTMeSaveMoneyShowType;

typedef enum : NSUInteger {
    BTTSaveMoneyTimesTypeLessTen, ///< 小于十次
    BTTSaveMoneyTimesTypeMoreTen  ///< 多余十次
} BTTSaveMoneyTimesType;

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

typedef enum {
    BTTConfirmSelect = 1, ///只有一張券
    BTTOneWaySelect, ///一張券以上的第一張
    BTTTwoWaySelect,    ///兩張券以上
    BTTOneWaySelectAndConfirm, ///一張券以上的最後一張
}BTTMenualSelectMode;

typedef void (^CompleteBlock)(IVJResponseObject *response);

typedef void (^BTTLive800ResponseBlock)(NSString *info);

/***********************************************存储关键字******************************************************/

/**********************************************通知常量*******************************************************/

#define BTTShowAccountGride                        @"BTTShowAccountGride"
#define BTTBiBiCunDate                             @"BTTBiBiCunDate"
#define BTTShareNoticeTag                          @"BTTShareNoticeTag"
#define BTTShowYuFenHong                           @"BTTShowYuFenHong"
#define BTTShowSevenXi                             @"BTTShowSevenXi"
#define BTTBeforeLoginDate                         @"BTTBeforeLoginDate"
#define BTTAlreadyShowNoDesposit                   @"BTTAlreadyShowNoDesposit"
#define BTTRegistDate                              @"BTTRegistDate"
#define BTTShowDefaultPopDate                      @"BTTShowDefaultPopDate"
#define BTTGameCurrencysWithName                   [NSString stringWithFormat:@"%@GameCurrencys", [IVNetwork savedUserInfo].loginName]
#define reload918Sec 20 * 60

#define BTTHome                                    0
//#define BTTAppPhone                                1
#define BTTLuckyWheel                              1
#define BTTPromo                                   2
#define BTTMine                                    3

//Flurry
#define FlurryKey                                  @"RY7GPP2V792PMZK3PYNX"

//live800相关
#define Live800SkillId                             @"10"

#define BTTBannerDefaultWidth                      1280
#define BTTBnnnerDefaultHeight                     440
#define BTTDiscountDefaultCellHeight               130
#define BTTDiscountIconWidth                       130
#define BTTDiscountDefaultIconHeight               90

#define BTTNavHeightNotLogin                       (KIsiPhoneX ? (88 + 49) : 113)
#define BTTNavHeightLogin                          (KIsiPhoneX ? 88 : 64)

//听云相关
#define TingYunAppId                               @"402c4df0e9124425ba0b2feb76d120b0"

// VOIP
#define BTTVoiceCallNumKey                         @"BTTVoiceCallNumKey"

#define BTTUIDKey                                  @"BTTUIDKey"

#define BTTVoiceCallResetTabbar                    @"BTTVoiceCallResetTabbar"

#define BTTWelcomePage                             @"BTTWelcomePage"
#define BTTLaunchScreenTime                        3

#define BTTUnreadMessageNumKey                     @"BTTUnreadMessageNumKey"

#define BTTVerisionUpdateKey                       @"BTTVerisionUpdateKey"

#define BTTWithDrawToday                           @"BTTWithDrawToday"
#define BTTConsetiveWinsToday                      @"BTTConsetiveWinsToday"

// 存款超过十次的用户

#define BTTSaveMoneyMoreThenTenKey                 @"BTTSaveMoneyMoreThenTenKey"

#define BTTBMerchantStatus                         @"BTTBMerchantStatus"

#define IVCheckUpdateNotification                  @"IVCheckUpdateNotification"

// 客户存款次数key

#define BTTSaveMoneyTimesKey                       @"BTTSaveMoneyTimesKey"

// 客户存款次数通知

#define BTTSaveMoneyTimesNotification              @"BTTSaveMoneyTimesNotification"

// 验证码发送按钮控制通知

#define BTTVerifyCodeEnableNotification            @"BTTVerifyCodeEnableNotification"
#define BTTVerifyCodeDisableNotification           @"BTTVerifyCodeDisableNotification"
#define BTTVerifyCodeSendNotification              @"BTTVerifyCodeSendNotification"

// PublicBtnCell按钮通知
#define BTTPublicBtnEnableNotification             @"BTTPublicBtnEnableNotification"
#define BTTPublicBtnDisableNotification            @"BTTPublicBtnDisableNotification"

// 注册成功页面通知: 1. 首页. 2. 个人中心

#define BTTRegisterSuccessGotoHomePageNotification @"BTTRegisterSuccessGotoHomePageNotification"
#define BTTRegisterSuccessGotoMineNotification     @"BTTRegisterSuccessGotoMineNotification"

//状态栏样式
#define StatusBarStyle                             UIStatusBarStyleLightContent

// 小红点常量宏

// 主页
#define BTTHomePage                                @"HomePage"
#define BTTHomePageItemsKey                        @"HomePageItemsKey"
#define BTTHomePageMessage                         @"HomePageMessage"
#define BTTDiscount                                @"Discount"
#define BTTDiscountItemsKey                        @"DiscountItemsKey"
#define BTTDiscountMessage                         @"DiscountMessage"

// 个人中心
#define BTTMineCenter                              @"MineCenter"
#define BTTMineCenterItemsKey                      @"MineCenterItemsKey"
#define BTTMineCenterMessage                       @"MineCenterMessage"
#define BTTMineCenterVersion                       @"MineCenterVersion"
#define BTTMineCenterNavMessage                    @"MineCenterNavMessage"

// 账号缓存key

#define BTTCacheAccountName                        @"BTTCacheAccountName"

#define BTTCoinTimestamp                           @"BTTCoinTimestamp"

//

// 昵称缓存字段
#define BTTNicknameCache                           @"BTTNicknameCache"
#define BTTLoginName                               @"loginName"

#define BTTBindUsdtCount                           @"BTTBindUsdtCount"
#define BTShowDBPopView                            @"BTShowDBPopView"
/*********************************************Video Game Key********************************************************/
#define BTTAGQJKEY                                 @"003"
#define BTTAGGJKEY                                 @"026"
#define BTTSABAKEY                                 @"031"
#define BTTASKEY                                   @"064"
#define BTTAGLotteryKEY                            @"004"
#define BTTPPKEY                                   @"067"
#define BTTTTGKEY                                  @"027"
#define BTTPTKEY                                   @"039"
#define BTTPSKEY                                   @"094"
#define BTTMGKEY                                   @"035"
//下方是沒有多幣種(CNY USDT)的
#define BTTBTIKEY                                  @"062"
#define BTTNBKEY                                   @"069"
#define BTTCSKEY                                   @"087"

//儲存使用者選擇幣種相對應的keyArr
#define BTTGameKeysArr                             @[BTTAGQJKEY,BTTAGGJKEY,BTTASKEY,BTTSABAKEY,BTTAGLotteryKEY,BTTPTKEY,BTTTTGKEY,BTTPPKEY,BTTPSKEY,BTTMGKEY]
#define BTTGameTitlesArr                           @[@"AG旗舰厅", @"AG国际厅", @"AS真人棋牌", @"沙巴体育", @"AG彩票", @"PT", @"TTG", @"PP", @"PS", @"MG"]

/*********************************************API********************************************************/

// 登录注册

#define BTTPassword                                @"password"
#define BTTTimestamp                               @"timestamp"

#define BTTParentID                                @"parent_id"
#define BTTPhone                                   @"phone"

#define BTTSelectedBankId                          @"BTTSelectedBankId"
#define BTTCacheBankListKey                        @"BTTCacheBankListKey"
#define BTTCacheBTCRateKey                         @"BTTCacheBTCRateKey"

/*********************************************平台API********************************************************/

// 登录注册
#define BTTUserLoginAPI                            @"customer/login"
// 模糊登录
#define BTTUserLoginEXAPI                          @"customer/loginEx"
// 異地登入
#define BTTUserLoginWith2FA                        @"customer/loginWith2FA"
// 验证登录名是否存在
#define BTTCheckLoginname                         @"customer/checkLoginName"
// 根据手机验证码登录
#define BTTUserLoginByMobileNo                     @"customer/loginByMobileNo"
// 生成图片验证
#define BTTVerifyCaptcha                           @"captcha/generate"
// 生成漢字图片验证
#define BTTChineseVerifyCaptcha                    @"captcha/generateCaptcha"
// 驗證漢字圖片驗證碼
#define BTTCheckChineseCaptcha                     @"captcha/validateCaptcha"
// 创建账号
#define BTTUserRegister                            @"customer/createRealAccount"
// 手機创建账号
#define BTTMobileUserRegister                      @"customer/createAccountByMobileNo"
// 验证短信验证码
#define BTTVerifySmsCode                           @"phone/verifySmsCode"
// 发送短信验证码
#define BTTSendMsgCode                             @"phone/sendCode"
// 根据用户名发送验证码
#define BTTStepOneSendCode                         @"phone/sendCodeByLoginName"
// 绑定手机号
#define BTTBindPhone                               @"phone/bind"
// update绑定手机号
#define BTTBindPhoneUpdate                         @"phone/updateBind"
//忘记密码第一步验证
#define BTTValidateCaptcha                         @"customer/preForgetPwd"
// 根据code修改密码
#define BTTStepThreeUpdatePassword                 @"customer/modifyPwdByCode"
// 根据登录名获取用户信息
#define BTTGetLoginInfoByName                      @"customer/getByLoginName"
// 根据登录名获取会员统计信息
#define BTTGetLoginInfoByNameEx                    @"customer/getByLoginNameEx"
// 查询400热线
#define BTT400Line                                 @"queryVIPLine"
// 解锁账号
#define BTTUnlockAccount                           @"customer/unlockAccount"
// 修改用户基本信息
#define BTTModifyCustomerInfo                      @"customer/modify"
// 查询会员账户接口银行卡和虚拟币
#define BTTAccountQuery                            @"account/query"
// 电话回拨API
#define BTTCallBackAPI                             @"callback"
// 添加银行卡账号
#define BTTAddBankCard                             @"account/create"
// 修改银行卡账号
#define BTTModifyBankCard                          @"account/modifyBank"
// 查询会员修改银行卡
#define BTTModifyBankRequests                      @"customer/checkPhoneAndBankCard"
// zi账户
#define BTTSwitchAccount                           @"customer/switchAccount"
// 删除银行卡
#define BTTDeleteBankAccount                       @"account/delete"
// 获取USDT钱包下钱包
#define BTTUsdtWallets                             @"deposit/queryDepositBankInfos"
// 设置默认取款卡
#define BTTSetDefaultCard                          @"account/setDefaultBankCard"
/// 查询存款方式
#define kPaymentValidate                           @"deposit/queryPayWaysV3"
// 获取用户额度信息全厅
#define BTTCreditsALL                              @"customer/getBalance"
// 金额转账本地接口
#define BTTTransferAllMoneyToLocal                 @"game/transferToLocal"
// 转账, 到PT
#define BTTTransferToGame                          @"game/transferToGame"
// 获取限红额度
#define BTTBetLimits                               @"limitRed/query"
// 申请修改限红
#define BTTLimitRedModify                          @"limitRed/modify"
// 查询订阅状态查询
#define BTTSubscriptionQuery                       @"subscribe/query"
// 修改订阅状态查询
#define BTTSubscriptionModify                      @"subscribe/modify"
// 开户礼金和存款礼金即可欧 ---NO
#define BTTOpenAccountStatus                       @"/A01/openAccount/isOpen"
// 请求未读消息的数量
#define BTTIsUnviewedAPI                           @"letter/countUnread"
// 人工存款信息错误重新提交---NO
#define BTTDepositResubmmitAPI                     @"/A01/payment/reSubmitDepositRequestEndpoint"
// 迅捷存款信息错误重新提交---NO
#define BTTBQAddOrderAPI                           @"/A01/payment/BQAddOrder"
// 手工存款催单 ---NO
#define BTTCreditAppealAPI                         @"/A01/payment/createCreditAppeal"
// 迅捷, 在线催款催单接口---NO
#define BTTAreditAppealAPI                         @"/A01/payment/createAreditAppeal"
// 查询存款金额列表
#define BTTQueryAmountList                         @"deposit/queryAmountList"
// 查询洗码额度v2
#define BTTXimaAmount                              @"xm/calcAmountV2"
#define QUERYGames                                 @"game/queryGames"
// 查询洗码提案列表
#define BTTXimaQueryRequest                        @"xm/queryRequest"
// 查询BQ存款银行
#define BTTQueryBQBankList                         @"deposit/queryBQBanks"
// 查询USDT汇率
#define BTTCurrencyExchanged                       @"deposit/currencyExchange"
// USDT手工支付存款
#define BTTManualPay                               @"deposit/createManualDepositRequest"
// 在线支付
#define BTTCreateOnlineOrder                       @"deposit/createOnlineOrder"
// 查询在线支付银行列表
#define BTTQueryOnlineBanks                        @"deposit/queryOnlineBanks"
// 创建在线支付订单
#define BTTCreateOnlineOrder                       @"deposit/createOnlineOrder"
// 创建在线支付订单
#define BTTCreateOnlineOrderV2                     @"deposit/createOnlineOrderV2"
// 查询人工存款账号
#define BTTQueryManualAccount                      @"deposit/queryManualDepositAccount"
// 邮箱发送验证码
#define BTTEmailSendCode                           @"email/sendCode"
// 邮箱发送验证码LoginName
#define BTTEmailSendCodeLoginName                  @"email/sendCodeByLoginName"
// 邮箱验证码验证
#define BTTEmailCodeVerify                         @"email/verifySmsCode"
// 邮箱绑定
#define BTTEmailBind                               @"email/bind"
// 邮箱绑定update
#define BTTEmailBindUpdate                         @"email/updateBind"
// 修改登录密码
#define BTTModifyLoginPwd                          @"customer/modifyPwd"
// 修改新用戶密碼
#define BTTModifyNewAccPwd                         @"customer/modifyTempLoginName"
// 发起取款
#define BTTWithDrawCreate                          @"withdraw/createRequest"
// BTCRate
#define BTTWithDrawBTCRate                         @"withdraw/queryBtcRate"
//
#define BTTBQPayment                               @"deposit/BQPayment"
//
#define BTTXiMaRequest                             @"xm/createRequest"
//点卡存款
#define BTTPointCardPayment                        @"deposit/pointCardPayment"
//查询点卡
#define BTTQueryPointCardList                      @"deposit/queryPointCardList"
//查询点卡
#define BTTCreateBfbAccount                        @"account/createGoldAccount"
//查询USDT钱包类型
#define BTTQueryUSDTWallet                         @"account/queryWalletType"
//查询USDT钱包类型
#define BTTQueryCounterQRCode                      @"deposit/queryDepositCounterQRCode"
//查询USDT钱包类型
#define BTTQueryCounterList                        @"deposit/queryDepositCounterExchangeInfo"
//充值购买USDT链接
#define BTTBuyUSDTLINK                             @"deposit/queryDepositCounter"
//
#define BTTUnreadInsideMessage                     @"letter/query"
//
#define BTTReadInsideMessage                       @"letter/batchViewLetter"
//
#define BTTOneKeyRegister                          @"customer/createAccountAuto"
//
#define BTTIsBindStatusAPI                         @"/public/verify/isNewBind"
//
#define BTTGamePlatforms                           @"/A01/game/platforms"
//
#define BTTDynamicQuery                            @"dynamic/query"
//客户报表 - 存款
#define BTTCustomerReportDeposit                   @"deposit/queryTrans"
//客户报表 - 存款 - 删除记录
#define BTTDeleteDepositRecord                     @"deposit/deleteTrans"
//客户报表 - 取款
#define BTTCustomerReportWithdraw                  @"withdraw/queryRequest"
//客户报表 - 取款 - 删除记录
#define BTTDeleteWithdrawRecord                    @"withdraw/deleteRequest"
//客户报表 - 取款 - 取消請求
#define BTTCancelWithdrawRequest                   @"withdraw/cancelRequest"
//客户报表 - 优惠
#define BTTCustomerReportPromo                     @"promo/queryRequest"
//客户报表 - 优惠 - 删除记录
#define BTTDeletePromoRecord                       @"promo/deleteRequest"
//客户报表 - 转账
#define BTTCustomerReportCredit                    @"credit/queryCreditLogs"
//客户报表 - 转账洗碼數據
#define BTTCustomerReportCreditXm                  @"deposit/queryCreditExchange"
//客户报表 - 转账 - 删除记录
#define BTTDeleteCreditRecord                      @"credit/deleteCreditLog"
//客户报表 - 洗码
#define BTTCustomerReportXm                        @"xm/queryRequest"
//客户报表 - 洗码 - 删除记录
#define BTTDeleteXmRecord                          @"xm/deleteRequest"
//客户报表 - 銀行卡更改
#define BTTCustomerReportBank                      @"account/queryModifyBankRequests"

//活期理財 - 轉賬記錄
#define BTTLiCaiTransferRecords                    @"yeb/yebTransferLogs"
//活期理財 - 理財額度記錄
#define BTTLiCaiWallet                             @"yeb/yebInterestCreditLogs"
//活期理財 - 配置信息
#define BTTLiCaiConfig                             @"yeb/yebConfig"

//活期理財 - 轉出至賬戶餘額
#define BTTLiCaiTransferOut                        @"yeb/transferOut"
//活期理財 - 轉入理財錢包
#define BTTLiCaiTransferIn                         @"yeb/transferIn"


/*********************************************產品API********************************************************/

//USDT取款限額
#define BTTUsdtLimit                               @"_extra_/api/v1/getLimitUSDT"
//app语音未登录回拨
#define BTTVoiceCall                               @"_extra_/api/v1/app/public/appCall"
//app语音登录回拨
#define BTTVoiceCallLogin                          @"_extra_/api/v1/app/public/appCallByLogin"
// 验证账号信息
#define BTTCheckAccountInfo                        @"_extra_/api/v1/ws/check-account-info"
// 首页聚合
#define BTTHomePageNewAPI                          @"_extra_/api/v1/app/indexCombo"
// 首页banner
#define BTTIndexBannerDownloads                    @"_extra_/api/v1/app/banners?v=1.1"
// 首页form
#define BTTBrandHighlights                         @"_extra_/api/v1/wms/form"
// 首页公告
#define BTTHomeAnnouncementAPI                     @"_extra_/api/v1/other/announcement/common"
// 优惠列表
#define BTTPromotionList                           @"_extra_/api/v1/wms/promotions?v=1.1"
// 请求游戏列表
#define BTTVideoGamesList                          @"_extra_/api/v1/wms/game?v=1.1"
// 获取收藏列表
#define BTTFavotiteList                            @"_extra_/api/v1/wms/gameFavorList"
// 添加收藏
#define BTTAddFavotites                            @"_extra_/api/v1/wms/gameFavor"
// 查询每日存款次数
#define BTTQueryTakeMoneyTimes                     @"_extra_/api/v1/getWithDrawByDay"
// 搏币数量查询
#define BTTQueryIntegralAPI                        @"_extra_/api/v1/activity/luckyWheel/myLeftPrize"
// 搏币兑换
#define BTTCoinDepositAPI                          @"_extra_/api/v1/activity/luckyWheel/depositPrize"
// 客户存款次数的接口
#define BTTSaveMoneyTimesAPI                       @"_extra_/api/v1/app/deposit/getIsDepositAmount"
// 查询可分享链接
#define BTTGetWeiXinRediect                        @"_extra_/api/v1/app/public/getWeiXinRedirect"
// 查询洗码历史记录
#define BTTXiMaHistoryListUrl                      @"_extra_/api/v1/getBetAmountByDay"
//查询是否开启币商充值
#define BTTQueryBiShangOpen                        @"_extra_/api/v1/agent/getBMerchantStatus"
//查询是否开启迅捷存款和开户礼金
#define BTTGiftRebateStatus                        @"_extra_/api/v1/app/promo/giftRebateStatus"
//查询是否开启迅捷存款和开户礼金
#define BTTOneKeySellUSDT                          @"_extra_/api/v1/getOTCStatus"
//
#define DSBHasBouns                                @"_extra_/api/v1/activity/newLuckyWheel/hasBonus"
//
#define DSBDrawBouns                               @"_extra_/api/v1/activity/newLuckyWheel/drawBonus"
//
#define BTTQueryLoginedShow                        @"_extra_/api/v1/activity/checkHasPop"
//優惠活動 - 筆筆存
#define BBTBiBiCunAlert                            @"_extra_/api/v1/activity/usdtFree2/alert"
//取款優惠彈窗
#define BTTGetPopWithDraw                          @"_extra_/api/v1/getPopWithDraw"
//是否顯示BiteBase
#define BTTIsShowBiteBase                          @"_extra_/api/v1/isShowBiteBase"
//2021月分紅是否是老用戶
#define BTTIsOldMember                             @"_extra_/api/v1/activity/monthly-activity2021/isVip"
//918贏牌-好運紅包及來
#define BTTFirtWinningList                         @"_extra_/api/v1/activity/winner/first-winning-list"
//vip優惠券自動派發
#define BTTVipHasPromo                             @"_extra_/api/v1/activity/vip-promo/has-promos"
//伺服器時間
#define BTTServerTime                              @"_extra_/api/v1/serverTime"
//活期理財 - 利息賬單紀錄
#define BTTLiCaiInterestRecords                    @"_extra_/api/v1/ws/query-yeb-interest-logs"
//活期理財 - 累積收益
#define BTTLiCaiInterestSum                        @"_extra_/api/v1/ws/yeb-interest-logs-sum"
//龍舟活動ㄦ-查询用户机会次数统计
#define BTTDragonBoatChance                        @"_extra_/api/v1/activity/dragon-boat-festival-2021/chance"
#define BTTDragonBoatCurrRound                     @"_extra_/api/v1/activity/dragon-boat-festival-2021/currRound"
#define BTTDragonBoatAssignLottery                 @"_extra_/api/v1/activity/dragon-boat-festival-2021/assignLottery"
//七夕活动用
#define BTTSevenXiDataBridge                       @"_extra_/api/v1/activity/"
//WMS弹窗查询(暂时)
#define BTTCheckPopView                            @"_extra_/api/v1/activity/five-lottery/windows-popup"

/********************************************常用宏*********************************************************/

#define kFontSystem(X)      ([UIFont systemFontOfSize:X])
#define kFontWeightLight(X) ([UIFont systemFontOfSize:X weight:UIFontWeightLight])
#define kFontSystemBold(X)  ([UIFont boldSystemFontOfSize:X])
#define kFontMedium(X)      ([UIFont fontWithName:@"STHeitiSC-Medium" size:X])
#define kFontLight(X)       ([UIFont fontWithName:@"STHeitiSC-Light" size:X])
#define kFontArialMT(X)     ([UIFont fontWithName:@"ArialMT" size:X])

// app_version版本号
#define app_version   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define build_version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

//沙盒中web资源目录
#define WebAppPath    [NSString stringWithFormat:@"%@/webApp", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
//沙盒中热更资源目录
#define HotAppPath    [NSString stringWithFormat:@"%@/hotApp", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
//沙盒中h5增量更新资源目录
#define ZLAppPath     [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"zl.zip"]
#define LocalHtmlPath(url)     [NSString stringWithFormat:@"%@/__html/%@", WebAppPath, url]

//带有RGBA的颜色设置
#define COLOR_RGBA(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]

//定义UIImage对象
#define ImageNamed(A)          [UIImage imageNamed:A]

// 定义弱引用
#define weakSelf(weakSelf)     __weak __typeof(&*self) weakSelf = self;
#define strongSelf(strongSelf) __strong __typeof(&*weakSelf) strongSelf = weakSelf;

#define SCREEN_WIDTH                     ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                    ([UIScreen mainScreen].bounds.size.height)
// tabbar 适配iPhone X
#define kTabbarHeight                    (KIsiPhoneX ? (BTTDangerousAreaH + 49) : 49)
// 是否为iPhoneX
#define KIsiPhoneX                       (((int)((SCREEN_HEIGHT / SCREEN_WIDTH) * 100) == 216) ? YES : NO)
#define BTTDangerousAreaH                34

//导航栏title样式
#define NavigationBarTitleTextAttributes [NSDictionary dictionaryWithObjectsAndKeys: \
                                          [UIColor whiteColor], NSForegroundColorAttributeName, \
                                          kFontSystem(17.0),    NSFontAttributeName, \
                                          nil]

// 判断obj是否为空
#define A01IsEmpty(_object) (_object == nil \
                             || [_object isKindOfClass:[NSNull class]] \
                             || ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
                             || ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//主题
#define App_Theme                        [NSDictionary dictionaryWithObjectsAndKeys: \
                                          [UIColor whiteColor],      NSForegroundColorAttributeName, \
                                          COLOR_RGBA(42, 45, 53, 1), NSBackgroundColorAttributeName, \
                                          [UIColor whiteColor],      NSLaunchTitleColorAttributeName, \
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
        if (!initialized) \
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
#define dispatch_main_sync_safe(block){ \
        if ([NSThread isMainThread]) { \
            block(); \
        } else { \
            dispatch_sync(dispatch_get_main_queue(), block); \
        } }
//----------防止在主线程调用dispatch_main出现异步问题----
#define dispatch_main_async_safe(block) \
    if ([NSThread isMainThread]) { \
        block(); \
    } else { \
        dispatch_async(dispatch_get_main_queue(), block); \
    }

//Alert
#define SHOWALERT(title, msg, cancel) do { \
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil]; \
        [alertview show]; } while (0)

#endif

#ifndef isDictWithCountMoreThan0

#define isDictWithCountMoreThan0(__dict__) \
    (__dict__ != nil && \
     [__dict__ isKindOfClass:[NSDictionary class] ] && \
     __dict__.count > 0)

#endif

#ifndef isArrayWithCountMoreThan0

#define isArrayWithCountMoreThan0(__array__) \
    (__array__ != nil && \
     [__array__ isKindOfClass:[NSArray class] ] && \
     __array__.count > 0)

#endif /* Constants_h */
