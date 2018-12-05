//
//  CNPayWechatTipView.h
//  Hybird_A01
//
//  Created by cean.q on 2018/12/3.
//  Copyright © 2018 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNPayWechatTipView : UIView <UIScrollViewDelegate>
+ (void)showWechatTip;
@property (weak, nonatomic) IBOutlet UIPageControl *pageC;
@end

NS_ASSUME_NONNULL_END
