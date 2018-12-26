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
            
        case CNPayChannelAli:
            self.channelName    = @"支付宝";
            self.selectedIcon   = @"pay_AliHL";
            break;
        case CNPayChannelCard:
            self.channelName    = @"点卡支付";
            self.selectedIcon   = @"pay_cardHL";
            break;
        case CNPayChannelWechat:
            self.channelName    = @"微信";
            self.selectedIcon   = @"pay_WeChatHL";
            break;
        case CNPayChannelBTC:
            self.channelName    = @"比特币支付";
            self.selectedIcon   = @"pay_btcHL";
            break;
        case CNPayChannelJD:
            self.channelName    = @"京东";
            self.selectedIcon   = @"pay_JDHL";
            break;
        case CNPayChannelCoin:
            self.channelName    = @"钻石币支付";
            self.selectedIcon   = @"pay_Bibao";
            break;
        case CNPayChannelQQ:
            self.channelName    = @"QQ";
            self.selectedIcon   = @"pay_AliHL";
            break;
        case CNPayChannelBankCard:
            self.channelName    = @"银行卡";
            self.selectedIcon   = @"me_netbank";
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
