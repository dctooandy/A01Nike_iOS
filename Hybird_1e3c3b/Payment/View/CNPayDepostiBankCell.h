//
//  CNPayDepostiBankCell.h
//  Hybird_1e3c3b
//
//  Created by cean.q on 2018/11/29.
//  Copyright © 2018 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNPayDepositNameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNPayDepostiBankCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *deteletBtn;
@property (copy, nonatomic) dispatch_block_t deleteHandler;
- (void)updateContent:(CNPayDepositNameModel *)model;
@end

NS_ASSUME_NONNULL_END
