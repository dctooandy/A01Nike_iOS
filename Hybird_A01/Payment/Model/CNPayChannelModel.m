//
//  CNPayChannelModel.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayChannelModel.h"

@interface CNPayChannelModel ()

/** 渠道名称 */
@property (nonatomic, copy, readwrite) NSString *channelName;

/** 渠道选中图标名称  */
@property (nonatomic, copy, readwrite) NSString *selectedIcon;

/** 渠道非选中状态图标名称 */
@property (nonatomic, copy, readwrite) NSString *normalIcon;

@end

@implementation CNPayChannelModel

- (void)setPayChannel:(CNPayChannel)payChannel {
    _payChannel = payChannel;
    
    switch (payChannel) {
            
        case CNPayChannelOnline:
            self.channelName    = @"在线支付";
            self.selectedIcon   = @"pay_onlineHL";
            break;
        case CNPayChannelCard:
            self.channelName    = @"点卡支付";
            self.selectedIcon   = @"pay_cardHL";
            break;
        case CNPayChannelDeposit:
            self.channelName    = @"手工存款";
            self.selectedIcon   = @"pay_depositHL";
            break;
        case CNPayChannelBTC:
            self.channelName    = @"比特币支付";
            self.selectedIcon   = @"pay_btcHL";
            break;
        case CNPayChannelWechatBarCode:
            self.channelName    = @"微信条码支付";
            self.selectedIcon   = @"pay_wechatBarCode";
            break;
        case CNPayChannelCoin:
            self.channelName    = @"币宝支付";
            self.selectedIcon   = @"pay_Bibao";
            break;
        case CNPayChannelAliApp:
            self.channelName    = @"支付宝WAP";
            self.selectedIcon   = @"pay_AliHL";
            break;
        case CNPayChannelUnionApp:
            self.channelName    = @"银行快捷支付";
            self.selectedIcon   = @"pay_unionHL";
            break;
        case CNPayChannelJDApp:
            self.channelName    = @"京东WAP";
            self.selectedIcon   = @"pay_JDHL";
            break;
        case CNPayChannelQR:
            self.channelName    = @"扫码支付";
            self.selectedIcon   = @"pay_QRHL";
            break;
        case CNPayChannelBQFast:
            self.channelName    = @"迅捷网银";
            self.selectedIcon   = @"pay_fastHL";
            break;
        case CNPayChannelBQWechat:
            self.channelName    = @"微信秒存";
            self.selectedIcon   = @"pay_WeChatHL";
            break;
        case CNPayChannelBQAli:
            self.channelName    = @"支付宝秒存";
            self.selectedIcon   = @"pay_AliHL";
            break;
    }
}

- (BOOL)isAvailable {
    for (CNPaymentModel *model in self.payments) {
        if (model.isAvailable) {
            return YES;
        }
    }
    return NO;
}
@end
