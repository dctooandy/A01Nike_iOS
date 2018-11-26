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
            self.normalIcon     = @"pay_onlineN";
            self.selectedIcon   = @"pay_onlineHL";
            break;
        case CNPayChannelCard:
            self.channelName    = @"点卡支付";
            self.normalIcon     = @"pay_cardN";
            self.selectedIcon   = @"pay_cardHL";
            break;
        case CNPayChannelDeposit:
            self.channelName    = @"手工存款";
            self.normalIcon     = @"pay_depositN";
            self.selectedIcon   = @"pay_depositHL";
            break;
        case CNPayChannelBTC:
            self.channelName    = @"比特币支付";
            self.normalIcon     = @"pay_btcN";
            self.selectedIcon   = @"pay_btcHL";
            break;
        case CNPayChannelWechatBarCode:
            self.channelName    = @"微信条码";
            self.normalIcon     = @"pay_barCodeN";
            self.selectedIcon   = @"pay_barCodeHL";
            break;
        case CNPayChannelWechatApp:
            self.channelName    = @"微信支付";
            self.normalIcon     = @"pay_wechatN";
            self.selectedIcon   = @"pay_wechatHL";
            break;
        case CNPayChannelAliApp:
            self.channelName    = @"支付宝支付";
            self.normalIcon     = @"pay_AliN";
            self.selectedIcon   = @"pay_AliHL";
            break;
        case CNPayChannelQQApp:
            self.channelName    = @"QQ支付";
            self.normalIcon     = @"pay_QQN";
            self.selectedIcon   = @"pay_QQHL";
            break;
        case CNPayChannelUnionApp:
            self.channelName    = @"银联支付";
            self.normalIcon     = @"pay_unionN";
            self.selectedIcon   = @"pay_unionHL";
            break;
//        case CNPayChannelJDApp:
//            self.channelName    = @"京东支付";
//            self.normalIcon     = @"pay_JDN";
//            self.selectedIcon   = @"pay_JDHL";
//            break;
        case CNPayChannelQR:
            self.channelName    = @"扫码支付";
            self.normalIcon     = @"pay_QRUnionN";
            self.selectedIcon   = @"pay_QRUnionHL";
            break;
        case CNPayChannelBQFast:
            self.channelName    = @"快速支付";
            self.normalIcon     = @"pay_fastN";
            self.selectedIcon   = @"pay_fastHL";
            break;
        case CNPayChannelBQWechat:
            self.channelName    = @"微信转账";
            self.normalIcon     = @"pay_BQWeChatN";
            self.selectedIcon   = @"pay_BQWeChatHL";
            break;
        case CNPayChannelBQAli:
            self.channelName    = @"支付宝转账";
            self.normalIcon     = @"pay_BQAliN";
            self.selectedIcon   = @"pay_BQAliHL";
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
