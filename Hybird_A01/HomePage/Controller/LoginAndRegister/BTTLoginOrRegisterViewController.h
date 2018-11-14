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

typedef enum {
    BTTQuickRegisterTypeAuto,   // 自动
    BTTQuickRegisterTypeManual  // 手动
}BTTQuickRegisterType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginOrRegisterViewController : BTTCollectionViewController

@property (nonatomic, assign) BTTRegisterOrLoginType registerOrLoginType;

@property (nonatomic, assign) BTTLoginCellType loginCellType;

@property (nonatomic, assign) BTTQuickRegisterType qucikRegisterType;

@property (nonatomic, strong) UIImage *codeImage;

@end

NS_ASSUME_NONNULL_END
