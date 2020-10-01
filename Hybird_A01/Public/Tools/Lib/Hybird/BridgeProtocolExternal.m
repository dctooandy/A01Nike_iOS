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
#import "BTTTabbarController.h"
#import "AppDelegate.h"
#import "BTTPersonalInfoController.h"
#import "BTTBindingMobileController.h"
#import "BTTCardInfosController.h"
#import "BTTWithdrawalController.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTAGQJViewController.h"
#import "BTTAGGJViewController.h"
#import "BTTVideoGamesListController.h"
#import "BTTSaveMoneySuccessController.h"
#import "BTTSaveMoneyErrorModel.h"
#import "BTTSaveMoneyModifyViewController.h"
#import "NSString+MD5.h"
#import "BTTXimaController.h"
#import "BTTGamesTryAlertView.h"

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
    WebConfigModel *webConfigModel = [[WebConfigModel alloc] initWithDictionary:bridgeModel.data error:nil];
    webConfigModel.newView = YES;
    UIViewController *vc = nil;
    if (webConfigModel.isAGQJ) {
        vc = [BTTAGQJViewController new];
        [self.controller.navigationController pushViewController:vc animated:YES];
    } else if ([webConfigModel.gameCode isEqualToString:@"A01026"]) {
        vc = [BTTAGGJViewController new];
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
    return @(YES);
}

- (id)forward_inside:(BridgeModel *)bridgeModel
{
    if ([bridgeModel.data[@"type"] integerValue]) {
        switch ([bridgeModel.data[@"type"] integerValue]) {
                
            case 1: ///< 成功
            {
                NSLog(@"成功");
                BTTSaveMoneySuccessController *vc = [BTTSaveMoneySuccessController new];
                vc.time = bridgeModel.data[@"time"];
                vc.saveMoneyStatus = BTTSaveMoneyStatusTypeSuccess;
                [self.controller.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2: ///< 失败
                
            {
                NSLog(@"失败");
                BTTSaveMoneySuccessController *vc = [BTTSaveMoneySuccessController new];
                vc.saveMoneyStatus = BTTSaveMoneyStatusTypeFail;
                [self.controller.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 3: /// 处理中
                
            {
                NSLog(@"处理中");
                BTTSaveMoneySuccessController *vc = [BTTSaveMoneySuccessController new];
                vc.saveMoneyStatus = BTTSaveMoneyStatusTypeOnGoing;
                [self.controller.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 4:
                
            {
                BTTSaveMoneyErrorModel *model = [BTTSaveMoneyErrorModel yy_modelWithDictionary:bridgeModel.data[@"item"]];
                NSLog(@"失败");
                BTTSaveMoneyModifyViewController *vc = [BTTSaveMoneyModifyViewController new];
                vc.model = model;
                [self.controller.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 5:
                
            {
                BTTSaveMoneyErrorModel *model = [BTTSaveMoneyErrorModel yy_modelWithDictionary:bridgeModel.data[@"item"]];
                [self submitData:model];
            }
                break;
                
                
            default:
                break;
        }
        return @(YES);
    }
    WebConfigModel *webConfigModel = [[WebConfigModel alloc] initWithDictionary:bridgeModel.data error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isForwardNativePage = [self shouldForwardNatviePage:webConfigModel.url];
        if (!isForwardNativePage) {
            [super forward_inside:bridgeModel];
        }
    });
    return @(YES);
}

- (void)submitData:(BTTSaveMoneyErrorModel *)model {
    NSString *url = nil;
    NSDictionary *params = nil;
    if (model.trans_code == 1) {
        url = BTTCreditAppealAPI;
        params = @{@"customerId":model.customer_id,@"type":@"1",@"depositMethod":@"1",@"endPoint":@"5",@"referenceId":model.reference_id,@"productId":model.product_id,@"loginName":model.login_name,@"amount":model.amount,@"status":@(model.status),@"createBy":model.created_by,@"requestType":@"1"};
    } else {
        url = BTTAreditAppealAPI;
        NSString *depositMethod = @"6";
        params = @{@"billno":model.reference_id,@"loginname":model.login_name,@"endPoint":@"5",@"type":@"1",@"requestType":@"0",@"depositMethod":depositMethod};
    }
    [self.controller showLoading];
    [IVNetwork requestPostWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self.controller hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"您的存款提案已安排优先处理, 请耐心等待。" toView:nil];
        }
    }];
}


- (BOOL)shouldForwardNatviePage:(NSString *)url
{
    BOOL should = YES;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BTTTabbarController *tabVC = (BTTTabbarController *)app.window.rootViewController;
    if ([url containsString:@"customer/member_center.htm"]) {//会员中心
        tabVC.selectedIndex = 4;
        [self.controller.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([url containsString:@"customer/personal_info.htm"]){//完善个人资料
        [self.controller.navigationController pushViewController:[BTTPersonalInfoController new] animated:YES];
    }
    else if ([url containsString:@"customer/bind_mobile.htm"]){//绑定手机号
        BTTBindingMobileController *vc = [BTTBindingMobileController new];
        vc.mobileCodeType = BTTSafeVerifyTypeBindMobile;
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
    else if ([url containsString:@"customer/bank_list.htm"]){//银行卡列表
        BTTCardInfosController *vc = [BTTCardInfosController new];
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
    else if ([url containsString:@"promotions/promotion_list.htm"] ||
             [url containsString:@"common/promotion_list.htm"]){//优惠
        tabVC.selectedIndex = 3;
        [self.controller.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([url containsString:@"common/index.htm"]){//首页
        tabVC.selectedIndex = 0;
        [self.controller.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([url containsString:@"common/login.htm"] && ![IVNetwork savedUserInfo]){//登录
        [self goToLoginPage:true];
    }
    else if ([url containsString:@"customer/withdrawl.htm"]){//提现
        [self.controller.navigationController pushViewController:[BTTWithdrawalController new] animated:YES];
    }
    else if([url containsString:@"common/ximaOther.htm"]) {
        BTTXimaController *xima = [BTTXimaController new];
        [self.controller.navigationController pushViewController:xima animated:YES];
    }
    else if ([url containsString:@"common/agqj.htm"]) {
        if ([IVNetwork savedUserInfo]) {
            NSDictionary *params = @{@"currency": [IVNetwork savedUserInfo] ? [IVNetwork savedUserInfo].uiMode:@"CNY"};
            [self checkAccount:params];
        } else {
            [self showTryAlertViewWithBlock:^(UIButton * _Nonnull btn) {
                if (btn.tag == 1090) {
                    BTTAGQJViewController *vc = [BTTAGQJViewController new];
                    vc.platformLine = @"CNY";
                    [[CNTimeLog shareInstance] startRecordTime:CNEventAGQJLaunch];
                    [self.controller.navigationController pushViewController:vc animated:YES];
                } else {
                    [MBProgressHUD showError:@"请先登录" toView:nil];
                    [self goToLoginPage:true];
                }
            }];
        }
    }
    else if ([url containsString:@"common/switch_account.htm"]) {
        if ([IVNetwork savedUserInfo] && [[IVNetwork savedUserInfo].uiMode isEqual:@"CNY"]) {
            dispatch_time_t dipatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5));
            dispatch_after(dipatchTime, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeModeNotification" object:nil];
            });
            tabVC.selectedIndex = 4;
            [self.controller.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"请先登录" toView:nil];
            [self goToLoginPage:true];
        }
    }
    else {
        should = NO;
    }
    return should;
}

-(void)goToLoginPage:(BOOL)isWebIn {
    BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
    vc.isWebIn = isWebIn;
    vc.registerOrLoginType = BTTRegisterOrLoginTypeLogin;
    [self.controller.navigationController pushViewController:vc animated:YES];
}

-(void)checkAccount:(NSDictionary *)params {
    [IVNetwork requestPostWithUrl:QUERYGames paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        NSArray *lineArray = result.body[@"A01003"];
        if (nil != lineArray && lineArray.count >= 2) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择游戏币种" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            for (int i=0; i<lineArray.count; i++) {
                NSDictionary *json = lineArray[i];
                NSString *name = json[@"platformCurrency"];
                NSString *title = [name isEqualToString:@"USD"]||[name isEqualToString:@"USDT"] ? @"数字币USDT" : @"人民币CNY";
                UIAlertAction *unlock = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self gotoGame:name];
                }];
                [alertVC addAction:unlock];
                if (i == lineArray.count-1) {
                    UIAlertAction *closelock = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self gotoGame:@"USDT"];
                    }];
                    [alertVC addAction:closelock];
                    [self.controller presentViewController:alertVC animated:YES completion:nil];
                }
            }
        }else{
            if (nil == lineArray) {
                [self gotoGame:@"CNY"];
            }else{
                NSDictionary *json = lineArray[0];
                NSString *name = json[@"platformCurrency"];
                [self gotoGame:name];
            }
        }
    }];
}

- (void)gotoGame:(NSString *)currency {
    BTTAGQJViewController *vc = [BTTAGQJViewController new];
    [[CNTimeLog shareInstance] startRecordTime:CNEventAGQJLaunch];
    vc.platformLine = currency;
    [self.controller.navigationController pushViewController:vc animated:YES];
}

- (void)showTryAlertViewWithBlock:(BTTBtnBlock)btnClickBlock {
    BTTGamesTryAlertView *customView = [BTTGamesTryAlertView viewFromXib];
    if (SCREEN_WIDTH == 414) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 120, 132);
    } else {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 60, 132);
    }
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton *btn) {
        [popView dismiss];
        btnClickBlock(btn);
    };
}

- (id)forward_outside:(BridgeModel *)bridgeModel { // custom/VOIP
    WebConfigModel *webConfigModel = [[WebConfigModel alloc] initWithDictionary:bridgeModel.data error:nil];
    if ([webConfigModel.url isEqualToString:@"custom/VOIP"]) {
        [self registerUID];
        return @(YES);
    } else if ([webConfigModel.url isEqualToString:@"a01/versionUpdate"]) {
        [IVNetwork checkAppUpdate];
        return @(YES);
    } else {
        if (webConfigModel.newView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BTTBaseWebViewController *webVC = [[BTTBaseWebViewController alloc] init];
                webVC.webConfigModel = webConfigModel;
                [self.controller.navigationController pushViewController:webVC animated:YES];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.controller.webConfigModel = webConfigModel;
                [self.controller loadWebView];
            });
        }
        return @(NO);
    }
}

- (id)driver_ui:(BridgeModel *)bridgeModel {
    NSLog(@"%@",bridgeModel.data);
    return [super driver_ui:bridgeModel];
}

- (id)outside_updateUI:(BridgeModel *)bridgeModel {
    [super outside_updateUI:bridgeModel];
    return nil;
}
- (id)game_toGame:(BridgeModel *)bridgeModel {
    NSDictionary *data = bridgeModel.data;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (data && [data isKindOfClass:[NSDictionary class]] ) {
            NSString *provider = [data valueForKey:@"provider"];
            if ([self shouldForwardToNotSlotGameWithProvider:provider]) {
                return;
            };
            if ([data valueForKey:@"gameInfo"] && [[data valueForKey:@"gameInfo"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *gameInfo = [data valueForKey:@"gameInfo"];
                IVGameModel *model = [[IVGameModel alloc] initWithDictionary:gameInfo];
                if ([gameInfo valueForKey:@"game_provider"]) {
                    model.provider = [gameInfo valueForKey:@"game_provider"];
                } else {
                    model.provider = provider;
                }
                [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self.controller];
            }
        }
    });
    return @(YES);
}
//非电子游戏
- (BOOL)shouldForwardToNotSlotGameWithProvider:(NSString *)provider
{
    BOOL isSlot = NO;
    IVGameModel *model = [[IVGameModel alloc] init];;
    NSString *otherProvider = nil;
    if ([provider isEqualToString:kAGQJProvider]) {
        [self.controller.navigationController pushViewController:[BTTAGQJViewController new] animated:YES];
    } else if ([provider isEqualToString:kAGINProvider]) {
        [self.controller.navigationController pushViewController:[BTTAGGJViewController new] animated:YES];
    } else if ([provider isEqualToString:kASSlotProvider]) {
        model.cnName = @"AS真人棋牌";
        model.enName =  kASSlotEnName;
        model.provider = kASSlotProvider;
    } else if ([provider isEqualToString:@"BTI"]) {
        model.cnName = @"BTI体育";
        model.enName =  @"SBT_BTI";
        model.provider =  @"SBT";
    } else if ([provider isEqualToString:@"fish"]) {
        model.cnName =  kFishCnName;
        model.enName =  kFishEnName;
        model.provider = kAGINProvider;
        model.gameId = model.gameCode;
        model.gameType = kFishType;
    } else if ([provider isEqualToString:@"SB"]) {
        model.cnName = @"沙巴体育";
        model.enName =  kASBEnName;
        model.provider =  kShaBaProvider;
    } else if ([provider isEqualToString:kMGProvider]) {
        otherProvider = kMGProvider;
    } else if ([provider isEqualToString:@"AG"]) {
        otherProvider = @"AG";
    } else if ([provider isEqualToString:kPTProvider]) {
        otherProvider = kPTProvider;
    } else if ([provider isEqualToString:kTTGProvider]) {
        otherProvider = kTTGProvider;
    } else if ([provider isEqualToString:@"PP"]) {
        otherProvider = @"PP";
    } else if ([provider isEqualToString:@"PS"]) {
        otherProvider = @"PS";
    } else  {
        isSlot = YES;
    }
    if (model.provider) {
        [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self.controller];
    }
    if (otherProvider) {//电游大厅
        BTTVideoGamesListController *vc = [BTTVideoGamesListController new];
        vc.provider = otherProvider;
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
    return isSlot;
}
@end
