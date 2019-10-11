//
//  BTTXimaRecordButtonsView.h
//  Hybird_A01
//
//  Created by Domino on 10/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BTTButtonClickBlock)(UIButton *button);

@interface BTTXimaRecordButtonsView : UIView

@property (nonatomic, copy) BTTButtonClickBlock btnClickBlock;

+ (instancetype)viewFromXib;

@end

NS_ASSUME_NONNULL_END
