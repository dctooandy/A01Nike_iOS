//
//  BTTVIPClubWebViewController.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/10.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseWebViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^BTTClickEventBlock)(id value);
@interface BTTVIPClubWebViewController : BTTBaseWebViewController
@property (nonatomic, copy) BTTClickEventBlock clickEventBlock;
@end

NS_ASSUME_NONNULL_END
