//
//  BTTActivityManager.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/19.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SevenXiCallBack)(NSString * _Nullable response, NSString * _Nullable error);
typedef void(^PopViewCallBack)(NSString * _Nullable response, NSString * _Nullable error);
@interface BTTActivityManager : NSObject
SingletonInterface(BTTActivityManager);
//检查七夕活动日期
- (void)checkSevenXiDate;
//检查七夕活动接口资料(正式开跑后)
-(void)loadSevenXiDatawWithCompletionBlock:(SevenXiCallBack _Nullable)completionBlock;

//检查wms弹窗API
- (void)checkPopViewWithCompletionBlock:(PopViewCallBack _Nullable)completionBlock;
@end

NS_ASSUME_NONNULL_END
