//
//  OTCInsideCell.h
//  Hybird_A01
//
//  Created by Flynn on 2020/7/16.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTCInsideModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCInsideCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView * recommendTagImg;

- (void)cellConfigJson:(OTCInsideModel *)model;

@end

NS_ASSUME_NONNULL_END
