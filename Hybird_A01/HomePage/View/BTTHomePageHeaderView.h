//
//  BTTHomePageHeaderView.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    BTTNavTypeHomePage = 1,
    BTTNavTypeOnlyTitle = 2,
    BTTNavTypeMessageAndService,
    BTTNavTypeMessageServiceIcon
}BTTNavType;

typedef void (^BTTHomePageBtnClickBlock)(UIButton *button);

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageHeaderView : UIImageView

@property (nonatomic, copy) BTTHomePageBtnClickBlock btnClickBlock;

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame withNavType:(BTTNavType)navType;

@end

NS_ASSUME_NONNULL_END
