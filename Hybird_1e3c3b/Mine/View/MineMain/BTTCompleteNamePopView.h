//
//  BTTCompleteNamePopView.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 7/9/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CommitBtnBlock)(NSString * _Nullable nameStr);

@interface BTTCompleteNamePopView : BTTBaseAnimationPopView
@property (nonatomic, copy) CommitBtnBlock commitBtnBlock;
@end

NS_ASSUME_NONNULL_END
