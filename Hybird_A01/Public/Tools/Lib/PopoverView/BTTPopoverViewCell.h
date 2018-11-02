//
//  BTTPopoverViewCell.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/3.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTPopoverAction.h"

UIKIT_EXTERN float const BTTPopoverViewCellHorizontalMargin; ///< 水平间距边距
UIKIT_EXTERN float const BTTPopoverViewCellVerticalMargin; ///< 垂直边距
UIKIT_EXTERN float const BTTPopoverViewCellTitleLeftEdge; ///< 标题左边边距

@interface BTTPopoverViewCell : UITableViewCell

@property (nonatomic, assign) BTTPopoverViewStyle style;

/*! @brief 标题字体
 */
+ (UIFont *)titleFont;

/*! @brief 底部线条颜色
 */
+ (UIColor *)bottomLineColorForStyle:(BTTPopoverViewStyle)style;

- (void)setAction:(BTTPopoverAction *)action;

- (void)showBottomLine:(BOOL)show;

@end
