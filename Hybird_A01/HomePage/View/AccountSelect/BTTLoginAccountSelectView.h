//
//  BTTLoginAccountSelectView.h
//  Hybird_A01
//
//  Created by Domino on 11/02/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginAccountSelectView : BTTBaseAnimationPopView

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) NSArray *accounts;

@end

NS_ASSUME_NONNULL_END
