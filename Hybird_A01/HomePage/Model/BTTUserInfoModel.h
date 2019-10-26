//
//  BTTUserInfoModel.h
//  Hybird_A01
//
//  Created by Domino on 17/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTUserInfoModel : BTTBaseModel

@property (nonatomic, copy) NSString *address; ///<地址

@property (nonatomic, copy) NSString *avatar; ///< 用户头

@property (nonatomic, copy) NSString *bankCardNum;///<绑定银行卡张数

@property (nonatomic, copy) NSString *birthday; ///<出生日期

@property (nonatomic, copy) NSString *blackFlag;///<黑名单状态[0:否; 1:是]

@property (nonatomic, copy) NSString *btcNum;///<绑定比特币账号个数

@property (nonatomic, copy) NSString *cashCredit; ///< 本地现金额度

@property (nonatomic, copy) NSString *clubLevel; ///< 会员俱乐部等级

@property (nonatomic, copy) NSString *depositLevel; ///<会员信用等级

@property (nonatomic, copy) NSString *email; ///<会员邮件账号[遮盖]

@property (nonatomic, copy) NSString *emailBind; ///<邮件是否绑定[0:否; 1:是]

@property (nonatomic, copy) NSString *firstDepositDate; ///<首存时间

@property (nonatomic, copy) NSString *firstXmFlag; ///<是否存在首次洗码[0:否; 1:是]

@property (nonatomic, copy) NSString *gameCredit; ///< 本地游戏额度

@property (nonatomic, copy) NSString *gender; ///<性别

@property (nonatomic, copy) NSString *integral; ///<会员总积分

@property (nonatomic, copy) NSString *lastLoginDate; ///<上次登录时间

@property (nonatomic, copy) NSString *loginDate; ///<当前登录时间

@property (nonatomic, copy) NSString *loginNameFlag; ///< 是否可修改登录名, 1-可修改 0-不可修改

@property (nonatomic, copy) NSString *mobileNoBind; ///< 手机是否绑定[0:否; 1:是]

@property (nonatomic, copy) NSString *mobileNoMd5; ///< mobileNoMd5

@property (nonatomic, copy) NSString *nickName; ///< 昵称;\

@property (nonatomic, copy) NSString *promoAmountByMonth; ///<当月已领取总优惠额度

@property (nonatomic, copy) NSString *pwdExpireDays; ///>密码过期天数

@property (nonatomic, copy) NSString *rebatedAmountByMonth; ///< 当月已洗总洗码额度

@property (nonatomic, copy) NSString *registDate; ///< 注册日期

@property (nonatomic, copy) NSString *remark; ///< 备注

@property (nonatomic, copy) NSString *upgradeRequiredBetAmount; ///< 升星级所需投注额

@property (nonatomic, copy) NSString *verifyCode; ///< verifyCode

@property (nonatomic, copy) NSString *voiceVerifyStatus; ///< 语音验证状态[0:未验证;1:已验证]

@property (nonatomic, copy) NSString *weeklyBetAmount; ///<周有效投注额

@property (nonatomic, copy) NSString *xmFlag; ///< 是否可以自助洗码[0:否; 1:是]

@property (nonatomic, copy) NSString *beforeLoginDate; ///<上次登陆时间

@property (nonatomic, copy) NSString *checkId; ///< checkId凭证编号

@property (nonatomic, copy) NSString *currency; ///< 货币类型

@property (nonatomic, copy) NSString *customerId;  ///< 会员编号

@property (nonatomic, copy) NSString *customerType; ///< 会员类型[0:试玩; 1: 真钱]

@property (nonatomic, copy) NSString *devSignature; ///< 自动注册唯一标识[将该字段值和登陆名存放到客户端上]

@property (nonatomic, copy) NSString *loginName; ///< 会员登录名

@property (nonatomic, copy) NSString *messageId; ///< 验证码ID, 对应发送短信验证码返回体中的messageID[手机登陆必填]

@property (nonatomic, copy) NSString *mobileNo; ///< 会员手机号

//@property (nonatomic, copy) NSString *newWalletFlag; ///<< 启动新钱包标志[0:否; 1:是]

@property (nonatomic, copy) NSString *noLoginDays; ///<未登录天数

@property (nonatomic, copy) NSString *password; ///< 密码, 仅自动注册和创建试玩账号才返回

@property (nonatomic, copy) NSString *pd;  ///< 密码, 仅自动注册才返回- 加密形式返回

@property (nonatomic, copy) NSString *realName;  ///< 真实姓名

@property (nonatomic, copy) NSString *starLevel; ///<会员星级

@property (nonatomic, copy) NSString *starLevelName; ///< 会员星级名称

@property (nonatomic, copy) NSString *token; ///> 会员token, 用此新 token替换掉本地token

@property (nonatomic, copy) NSString *validateId; ///< 验证令牌编号

@end

NS_ASSUME_NONNULL_END
