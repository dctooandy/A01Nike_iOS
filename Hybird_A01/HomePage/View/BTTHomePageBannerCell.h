//
//  BTTHomePageBannerCell.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

#define BTTBannerDefaultWidth  1280
#define BTTBnnnerDefaultHeight 440

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageBannerCell : BTTBaseCollectionViewCell

@property (nonatomic, strong) NSMutableArray *imageUrls; ///< banner url数组

@end

NS_ASSUME_NONNULL_END
