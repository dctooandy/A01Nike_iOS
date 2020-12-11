//
//  BTTBaseViewController.h
//  A01_Sports
//
//  Created by Domino on 2018/9/21.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "HABaseViewController.h"
#import "MBProgressHUD+Add.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTBaseViewController : HABaseViewController

+ (BTTBaseViewController *)getVCFromStoryboard;

@property (nonatomic, strong) MBProgressHUD *hud;


@end

NS_ASSUME_NONNULL_END
