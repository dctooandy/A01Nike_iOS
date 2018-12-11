//
//  BTTLoginOrRegisterViewController.h
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

typedef enum {
    BTTLoginCellTypeNormal,    // 无码
    BTTLoginCellTypeCode       // 有码
}BTTLoginCellType;



NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginOrRegisterViewController : BTTCollectionViewController

@property (nonatomic, assign) BTTRegisterOrLoginType registerOrLoginType;///< 登录注册页面类型

@property (nonatomic, assign) BTTLoginCellType loginCellType;            ///< 登录cell类型

@property (nonatomic, assign) BTTQuickRegisterType qucikRegisterType;    ///< 快速注册类型

@property (nonatomic, strong) UIImage *codeImage;     ///< 图形验证码

@property (nonatomic, assign) NSInteger wrongPwdNum;  ///< 密码错误次数

@property (nonatomic, copy) NSString *uuid; ///< 验证码返回的uuid

@end

NS_ASSUME_NONNULL_END
