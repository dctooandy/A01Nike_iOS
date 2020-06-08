//
//  BTTBitollWithDrawCell.h
//  Hybird_A01
//
//  Created by Flynn on 2020/5/15.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTBitollWithDrawCell : UICollectionViewCell

@property (nonatomic, copy) void (^confirmTap)(void);
@property (nonatomic, copy) void (^bindTap)(void);
@property UIButton *confirmBtn;
- (void)setImageViewHidden:(BOOL)imgHidden onekeyHidden:(BOOL)onekeyHidden;
@end

NS_ASSUME_NONNULL_END
