//
//  BTTBaseViewController.h
//  A01_Sports
//
//  Created by Domino on 2018/9/21.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "HABaseViewController.h"
#import "BTTProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTTBaseViewController : HABaseViewController
@property(nonatomic, strong)BTTProgressHUD *hud;
+ (BTTBaseViewController *)getVCFromStoryboard;

@end

NS_ASSUME_NONNULL_END
