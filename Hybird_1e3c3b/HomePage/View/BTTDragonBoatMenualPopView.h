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
@property (strong, nonatomic) NSMutableArray *currentDataArray;
- (void)configForAmount:(NSInteger)amountValue;

@end

NS_ASSUME_NONNULL_END
