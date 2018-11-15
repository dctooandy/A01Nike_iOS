//
//  BTTUnlockPopView.h
//  Hybird_A01
//
//  Created by Domino on 13/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BTTUnlockDismissBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BTTUnlockPopView : UIView

+ (instancetype)viewFromXib;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) BTTUnlockDismissBlock dismissBlock;

@end

NS_ASSUME_NONNULL_END
