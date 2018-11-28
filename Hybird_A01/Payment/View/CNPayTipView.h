//
//  CNPayTipView.h
//  A05_iPhone
//
//  Created by cean.q on 2018/10/3.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNPayTipView : UIView
@property (nonatomic, copy) dispatch_block_t btnAcitonBlock;
+ (void)showTipView;
@end
