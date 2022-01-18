//
//  BTTActivityManager.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/19.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedPacketsInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CheckTimeCompleteBlock)(NSString * timeStr);
typedef void(^RedPacketCallBack)(NSString * _Nullable response, NSString * _Nullable error);
typedef void(^PopViewCallBack)(NSString * _Nullable response, NSString * _Nullable error);
@interface BTTActivityManager : NSObject
SingletonInterface(BTTActivityManager);
@property(nonatomic,strong)RedPacketsInfoModel * redPacketInfoModel;
//检查七夕活动接口资料(正式开跑后)
-(void)loadSevenXiData;

//检查wms弹窗API
- (void)checkPopViewWithCompletionBlock:(PopViewCallBack _Nullable)completionBlock;
// 检查红包雨
- (void)checkTimeForRedPoickets;

// 检查客制活动期间
- (void)checkTimeRedPacketRainWithCompletion:(RedPacketCallBack _Nullable)redPacketBlock WithDefaultCompletion:(RedPacketCallBack _Nullable)defaultBlock;
@end

NS_ASSUME_NONNULL_END
