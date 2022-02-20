//
//  KYMWithdrewSubmitView.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYMWidthdrewUtility.h"
NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrewSubmitView : UIView
@property (nonatomic ,assign) KYMWithdrewStatus status;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

NS_ASSUME_NONNULL_END
