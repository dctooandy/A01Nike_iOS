//
//  BTTLiCaiBannerCell.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/26/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^BannerClickBlock)(void);

@interface BTTLiCaiBannerCell : BTTBaseCollectionViewCell
@property (nonatomic, copy) BannerClickBlock bannerClickBlock;
@end

NS_ASSUME_NONNULL_END
