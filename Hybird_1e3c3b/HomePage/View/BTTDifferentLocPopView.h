//
//  BTTDifferentLocPopView.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 2/23/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^BTTConfirmBtnBlock)(NSString * str);
typedef void (^BTTSendCodeBtnActionBlock)(void);

@interface BTTDifferentLocPopView : BTTBaseAnimationPopView
@property (nonatomic, copy) BTTConfirmBtnBlock confirmBtnBlock;
@property (nonatomic, copy) BTTSendCodeBtnActionBlock sendCodeBtnAction;
- (void)countDown:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
