//
//  BTTBaseAnimationPopView.h
//  Hybird_A01
//
//  Created by Domino on 16/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BTTDismissBlock)(void);

typedef void (^BTTCallBackBlock)(NSString *phone);

typedef void (^BTTCallBackBtnBlock)(UIButton *btn);

NS_ASSUME_NONNULL_BEGIN

@interface BTTBaseAnimationPopView : UIView

+ (instancetype)viewFromXib;

@property (nonatomic, copy) BTTDismissBlock dismissBlock;

@property (nonatomic, copy) BTTCallBackBlock callBackBlock;

@property (nonatomic, copy) BTTCallBackBtnBlock btnBlock;

@end

NS_ASSUME_NONNULL_END
