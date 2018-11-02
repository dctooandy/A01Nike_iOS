//
//  BridgeProtocolExternal.m
//  Hybird_test
//
//  Created by Key on 2018/6/8.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BridgeProtocolExternal.h"
#import "CLive800Manager.h"
#import "BTTTabbarController.h"
#import "BTTVoiceCallViewController.h"
#import "JXRegisterManager.h"

@interface BridgeProtocolExternal ()<JXRegisterManagerDelegate>

@end

@implementation BridgeProtocolExternal

- (void)registerUID {
    
    JXRegisterManager *registerManager = [JXRegisterManager sharedInstance];
    registerManager.delegate = self;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:BTTUIDKey];
    [registerManager registerWithUID:uid];
}

#pragma mark- JXRegisterManagerDelegate
- (void)didRegisterResponse:(NSDictionary *)response {

}



- (id)driver_live800:(BridgeModel *)bridgeModel {
    [[CLive800Manager sharedInstance] startLive800Chat:self.controller];
    return nil;
}
- (id)driver_live800ol:(BridgeModel *)bridgeModel {
//    NSString *url = @"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=21&k=1&codeType=custom";
//    HAWebViewController *temp = [[HAWebViewController alloc] init];
//    temp.webConfigModel.newView = YES;
//    temp.webConfigModel.url = url;
//    weakSelf(weakSelf)
//    dispatch_main_async_safe((^{
//        strongSelf(strongSelf)
//        temp.navigationItem.title = @"在线客服";
//        [strongSelf.controller.navigationController pushViewController:temp animated:YES];
//    }));
    return @(YES);
}
- (id)driver_game:(BridgeModel *)bridgeModel {
   
    return @(YES);
}

- (id)forward_outside:(BridgeModel *)bridgeModel { // custom/VOIP
    WebConfigModel *webConfigModel = [[WebConfigModel alloc] initWithDictionary:bridgeModel.data error:nil];
    if ([webConfigModel.url isEqualToString:@"custom/VOIP"]) {
        [self registerUID];
        return @(YES);
    } else if ([webConfigModel.url isEqualToString:@"a01/versionUpdate"]) {
        [IVNetwork checkAppUpdate];
        return @(YES);
    }
    return [super forward_outside:bridgeModel];
}

- (id)driver_ui:(BridgeModel *)bridgeModel {
    NSLog(@"%@",bridgeModel.data);
    return [super driver_ui:bridgeModel];
}

- (id)outside_updateUI:(BridgeModel *)bridgeModel {
    [super outside_updateUI:bridgeModel];
    return nil;
}
@end
