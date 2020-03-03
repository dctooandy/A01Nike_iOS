//
//  BTTLoginInfoView.h
//  Hybird_A01
//
//  Created by Levy on 2/18/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginInfoView : UIView

@property (nonatomic, copy) void (^sendSmdCode)(NSString *phone);
@property (nonatomic, copy) void (^tapLogin)(NSString *account,NSString *password,BOOL isSmsCode,NSString *codeStr);
@property (nonatomic, copy) void (^tapRegister)(void);
@property (nonatomic, copy) void (^tapForgetAccountAndPwd)(void);
@property (nonatomic, strong) UIButton *imgCodeBtn;
@property (nonatomic, strong)UIView *codeImgView;
- (void)setCodeImage:(UIImage *)codeImg;

@property (nonatomic, copy) void(^refreshCodeImage)(void);

- (void)handleCodeImageView;
@end

NS_ASSUME_NONNULL_END
