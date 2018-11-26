//
//  CNPayTipView.h
//  A05_iPhone
//
//  Created by cean.q on 2018/10/3.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNPaySubmitButton.h"

@interface CNPayTipView : UIView
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) dispatch_block_t btnAcitonBlock;
+ (instancetype)tipView;
@end
