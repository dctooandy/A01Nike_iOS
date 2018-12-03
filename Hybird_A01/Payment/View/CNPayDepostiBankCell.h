//
//  CNPayDepostiBankCell.h
//  Hybird_A01
//
//  Created by cean.q on 2018/11/29.
//  Copyright © 2018 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNPayDepostiBankCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *deteletBtn;
@property (copy, nonatomic) dispatch_block_t deleteHandler;
@end

NS_ASSUME_NONNULL_END
