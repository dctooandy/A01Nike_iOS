//
//  VIPActivitiesImageCell.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/6/16.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPActivitiesImageCell : BTTBaseCollectionViewCell

-(void)configForTitle:(NSString *)title withImageUrl:(NSString *)imgUrl;
@end

NS_ASSUME_NONNULL_END
