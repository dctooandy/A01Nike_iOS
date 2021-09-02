//
//  BTTVIPChangeBtnsCell.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/4.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTVIPChangeBtnsCell : BTTBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *vipRightBtn;
@property (weak, nonatomic) IBOutlet UIButton *vipHistoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *vipActivityBtn;
- (IBAction)vipRightBtnClick:(nullable UIButton *)sender;
- (void)setupArrow;
@end

NS_ASSUME_NONNULL_END
