//
//  OTCInsideCell.h
//  Hybird_1e3c3b
//
//  Created by Flynn on 2020/7/16.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTCInsideModel.h"
 
NS_ASSUME_NONNULL_BEGIN

@interface OTCInsideCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView * recommendTagImg;
-(void)setBitbaseBgImg;
- (void)cellConfigJson:(OTCInsideModel *)model;

@end

NS_ASSUME_NONNULL_END
