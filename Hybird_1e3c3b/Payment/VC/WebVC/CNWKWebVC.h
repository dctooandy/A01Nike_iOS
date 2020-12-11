//
//  CNWKWebVC.h
//  HybirdApp
//
//  Created by cean.q on 2018/8/22.
//  Copyright © 2018年 AM-DEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HABaseViewController.h"

@interface CNWKWebVC : HABaseViewController
- (instancetype)initWithHtmlString:(NSString *)htmlString;
- (instancetype)initWithURLString:(NSString *)URLString;
@end
