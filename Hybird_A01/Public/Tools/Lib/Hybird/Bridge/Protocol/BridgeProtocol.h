//
//  BridgeProtocol.h
//  MainHybird
//
//  Created by Key on 2018/6/8.
//  Copyright © 2018年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HAWebViewController;
@class BridgeModel;
@interface BridgeProtocol : NSObject
@property(nonatomic, weak)HAWebViewController *controller;
- (id)net_invoke:(BridgeModel *)bridgeModel;
- (id)forward_inside:(BridgeModel *)bridgeModel;
- (id)forward_outside:(BridgeModel *)bridgeModel;
- (id)cache_clear:(BridgeModel *)bridgeModel;
- (id)cache_get:(BridgeModel *)bridgeModel;
- (id)cache_save:(BridgeModel *)bridgeModel;
- (id)cache_update:(BridgeModel *)bridgeModel;
- (id)cache_delete:(BridgeModel *)bridgeModel;
- (id)driver_ui:(BridgeModel *)bridgeModel;
- (id)driver_IPSUnread:(BridgeModel *)bridgeModel;
- (id)driver_clearCookie:(BridgeModel *)bridgeModel;
- (id)driver_deviceInfo:(BridgeModel *)bridgeModel;
- (id)driver_game:(BridgeModel *)bridgeModel;
- (id)driver_getParentId:(BridgeModel *)bridgeModel;
- (id)driver_getSessionId:(BridgeModel *)bridgeModel;

/**
 通知外部更新UI
 */
- (id)outside_updateUI:(BridgeModel *)bridgeModel;
/**
 外部调试js调用协议详情
 */
- (id)outside_debug:(BridgeModel *)bridgeModel;


@end
