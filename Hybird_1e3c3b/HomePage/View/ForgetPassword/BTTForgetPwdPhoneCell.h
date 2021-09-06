//
//  BTTForgetPwdPhoneCell.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/12/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseCollectionViewCell.h"

@class BTTMeMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetPwdPhoneCell : BTTBaseCollectionViewCell
@property (nonatomic, strong) BTTMeMainModel *model;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendSmsBtn;
-(void)countDown:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
