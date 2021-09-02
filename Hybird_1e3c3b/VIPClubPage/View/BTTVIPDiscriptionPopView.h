//
//  BTTVIPDiscriptionPopView.h
//  Hybird_1e3c3b
//
//  Created by Andy on 5/13/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"
//#import "BTTYenFenHongModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTTVIPDiscriptionPopView : BTTBaseAnimationPopView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backGroundViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *vipDiscriptionTextView;
@property (nonatomic ,assign) BTTVIPDiscriptionViewType discriptionViewType;
//@property (nonatomic, strong) BTTYenFenHongModel *model;

@end

NS_ASSUME_NONNULL_END
