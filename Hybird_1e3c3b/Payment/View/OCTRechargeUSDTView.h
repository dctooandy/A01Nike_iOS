//
//  OCTRechargeUSDTView.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 12/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTRechargeUSDTView : UIView
@property (nonatomic, strong) UIView *rechargeView;
@property (nonatomic, strong) UIButton *ercBtn;
@property (nonatomic, strong) UIButton *trcBtn;
@property (nonatomic, strong) UIButton *omniBtn;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UITextView *locationUrlTextView;
@property (nonatomic, strong) UIButton *urlCopyBtn;
@property (nonatomic, strong) UIImageView *qrcodeImg;
@end

NS_ASSUME_NONNULL_END
