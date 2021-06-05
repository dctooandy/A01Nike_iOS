//
//  BTTDragonBoatMenualPopView.h
//  Hybird_1e3c3b
//
//  Created by Andy on 6/3/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTDragonBoatMenualPopView : BTTBaseAnimationPopView
- (void)setCurrentCouponPage:(NSArray*)couponArray;
- (void)configForMenualValue:(NSString*)value withSelectMode:(BTTMenualSelectMode)mode;

@end

NS_ASSUME_NONNULL_END
