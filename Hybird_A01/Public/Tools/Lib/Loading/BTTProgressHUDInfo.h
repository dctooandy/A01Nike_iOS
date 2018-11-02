//
//  BTTProgressHUDInfo.h
//  Hybird_A01
//
//  Created by Domino on 2018/7/27.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BTTProgressHUDInfoModeType) {
    BTTProgressHUDInfoHUD = 0,//HUD
    BTTProgressHUDInfoCustom = 1//自定义
};

@interface BTTProgressHUDInfo : NSObject

@property (nonatomic,assign) CGRect imageViewFrame;

@property (nonatomic,assign) CGRect contentViewFrame;

@property (nonatomic,assign) CGRect HUDFrame;

@property (nonatomic,assign) CGRect textLabelFrame;

@property (nonatomic,assign) CGSize textSize;

@property (nonatomic,assign) CGRect iconFrame;

@property (nonatomic,assign) BOOL isWebView;


@property (nonatomic,assign) BTTProgressHUDInfoModeType infoModeType;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)layoutOnlyHUDWithFrame:(CGRect)frame;

- (void)layoutOnlyCustomWithFrame:(CGRect)frame;

- (void)layoutHUDWithText:(NSString *)text withFrame:(CGRect)frame;

- (void)layoutCustomWithText:(NSString *)text withFrame:(CGRect)frame;

- (void)layoutHUDOrCustomWithText:(NSString *)text withFrame:(CGRect)frame;

- (void)layoutOnlyTextWithText:(NSString *)text withFrame:(CGRect)frame;

- (void)layoutCustomWithText:(NSString *)text Width:(CGFloat)width height:(CGFloat)height withFrame:(CGRect)frame;

- (void)drawLoadingCircle:(CALayer *)HUDLayer;

- (void)drawStatusSuccess:(CALayer *)HUDLayer;

- (void)drawStatusFail:(CALayer *)HUDLayer;

- (void)drawProgressCircle:(CALayer *)HUDLayer progress:(CGFloat)progress;

@end

