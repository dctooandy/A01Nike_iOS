//
//  UserRightTableViewCell.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/11.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^BTTButtonClickBlock)(UIButton *button);
@interface UserRightTableViewCell : UITableViewCell
- (void)config:(BTTVIPClubUserRightPageType)cellType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (nonatomic, copy) BTTButtonClickBlock buttonClickBlock;
@end

NS_ASSUME_NONNULL_END
