//
//  BTTBaseWebViewController.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "HAWebViewController.h"
#import "MBProgressHUD+Add.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTBaseWebViewController : HAWebViewController

@property(nonatomic, strong) MBProgressHUD *hud;

@end

NS_ASSUME_NONNULL_END
