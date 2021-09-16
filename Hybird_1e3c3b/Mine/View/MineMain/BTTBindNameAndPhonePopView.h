//
//  BTTBindNameAndPhonePopView.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 7/10/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SendSmsBtnAction)(NSString *phone);

@interface BTTBindNameAndPhonePopView : BTTBaseAnimationPopView
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *phoneStr;
@property (weak, nonatomic) IBOutlet UIButton *sendSmsBtn;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, copy) SendSmsBtnAction sendSmsBtnAction;
- (void)countDown;
@end

NS_ASSUME_NONNULL_END
