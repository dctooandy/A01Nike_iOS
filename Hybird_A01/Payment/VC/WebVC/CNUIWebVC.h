//
//  CNUIWebVC.h
//  HybirdApp
//
//  Created by cean.q on 2018/11/12.
//  Copyright © 2018 harden-imac. All rights reserved.
//

#import "HAWebViewController.h"
#import "CNPayOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNUIWebVC : HAWebViewController
- (instancetype)initWithOrder:(CNPayOrderModel *)order title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
