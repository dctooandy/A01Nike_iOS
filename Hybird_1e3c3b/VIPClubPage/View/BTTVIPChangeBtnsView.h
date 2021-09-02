//
//  BTTVIPChangeBtnsView.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/12.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^BTTButtonClickBlock)(UIButton *button);
@interface BTTVIPChangeBtnsView : UIView
@property (nonatomic, copy) BTTButtonClickBlock buttonClickBlock;
@property (weak, nonatomic) IBOutlet UIButton *vipRightBtn;
@property (weak, nonatomic) IBOutlet UIButton *vipHistoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *vipActivityBtn;
- (IBAction)vipRightBtnClick:(nullable UIButton *)sender;
- (void)setupArrow;
@end

NS_ASSUME_NONNULL_END
