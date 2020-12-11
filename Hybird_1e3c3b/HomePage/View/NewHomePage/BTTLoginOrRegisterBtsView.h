//
//  BTTLoginOrRegisterBtsView.h
//  Hybird_1e3c3b
//
//  Created by Domino on 13/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BTTCallBackBtnBlock)(UIButton * _Nullable btn);

@interface BTTLoginOrRegisterBtsView : UIImageView

@property (nonatomic, copy) BTTCallBackBtnBlock btnClickBlock;

+ (instancetype)viewFromXib;

@end

NS_ASSUME_NONNULL_END
