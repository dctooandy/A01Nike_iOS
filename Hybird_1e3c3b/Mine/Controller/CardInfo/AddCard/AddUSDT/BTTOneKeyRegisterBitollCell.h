//
//  BTTOneKeyRegisterBitollCell.h
//  Hybird_1e3c3b
//
//  Created by Levy on 4/3/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTOneKeyRegisterBitollCell : UICollectionViewCell
@property (nonatomic,copy) void(^onekeyRegister)(void);
- (void)setIsHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
