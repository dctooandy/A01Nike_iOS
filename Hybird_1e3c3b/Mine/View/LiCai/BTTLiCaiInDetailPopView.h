//
//  BTTLiCaiInDetailPopView.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/28/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CloseBtnClickBlock)(UIButton * button);
typedef void (^TransferBtnClickBlock)(UIButton * button, NSString * amount);

@interface BTTLiCaiInDetailPopView : UIView
+ (instancetype)viewFromXib;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) CloseBtnClickBlock closeBtnClickBlock;
@property (nonatomic, copy) TransferBtnClickBlock transferBtnClickBlock;
@property  (nonatomic, copy) NSString * accountBalance;
@end

NS_ASSUME_NONNULL_END
