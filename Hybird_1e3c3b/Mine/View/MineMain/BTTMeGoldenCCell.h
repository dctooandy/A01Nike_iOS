//
//  BTTMeGoldenCCell.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/22/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTMeGoldenCCell : UICollectionViewCell
@property (nonatomic, copy) void(^clickAction)(NSInteger tag);
@end

NS_ASSUME_NONNULL_END
