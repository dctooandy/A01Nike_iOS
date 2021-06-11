//
//  CNUIWebVC.h
//  HybirdApp
//
//  Created by cean.q on 2018/11/12.
//  Copyright © 2018 harden-imac. All rights reserved.
//

#import "HAWebViewController.h"
#import "CNPayOrderModel.h"
#import "CNPayOrderModelV2.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNUIWebVC : HAWebViewController
- (instancetype)initWithOrder:(CNPayOrderModel *)order title:(NSString *)title;
- (instancetype)initWithV2Order:(CNPayOrderModelV2 *)order title:(NSString *)title;
- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
