//
//  OnekeySellUsdtCell.h
//  Hybird_1e3c3b
//
//  Created by Flynn on 2020/7/1.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OnekeySellUsdtCell : UICollectionViewCell
@property (nonatomic, copy) void (^oneKeySell)(void);
- (void)sellHidden:(BOOL)sellHidden;
@end

NS_ASSUME_NONNULL_END
