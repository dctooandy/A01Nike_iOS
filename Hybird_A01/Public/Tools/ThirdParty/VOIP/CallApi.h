//
//  CallApi.h
//  voip_sdk
//
//  Created by dw on 15/11/29.
//  Copyright (c) 2015年 dengw. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -- 状态枚举定义 --
/* 呼叫状态 CallStatus 说明
 CallStatus_None       初始状态/未知状态
 CallStatus_Ready      注册环境reday状态
 CallStatus_Calling    该状态有2种含义
                         1、正在呼叫状态，等待服务器响应（主动发起呼叫时
                         2.收到对方的呼叫请求
 CallStatus_Ringing    对方正在振铃（收到服务器回180）
 CallStatus_Connected  对方接通呼叫，呼叫已经建立
 CallStatus_Disconnected   呼叫挂断
 CallStatus_Failed     呼叫失败
 */
typedef enum {
  CallStatus_None,
  CallStatus_Ready,
  CallStatus_Calling,
  CallStatus_Ringing,
  CallStatus_Connected,
  CallStatus_Disconnected,
  CallStatus_Failed,
} CallStatus;

/* 登陆状态 SipRegisterStatus 说明
 SipRegStatus_Offline      离线状态
 SipRegStatus_Connecting   正在登录，等待服务器响应
 SipRegStatus_Connected    登陆成功
 SipRegStatus_Disconnecting  正在登出，等待服务端响应
 SipRegStatus_Failed       登陆失败
 */
typedef enum {
  SipRegStatus_Offline,
  SipRegStatus_Connecting,
  SipRegStatus_Connected,
  SipRegStatus_Disconnecting,
  SipRegStatus_Failed,
} SipRegisterStatus;

#pragma mark -- voip配置 --
@interface ApiConfig : NSObject {
}
/* 显示名/昵称，用来给对方显示
 由用户设置
 */
@property(nonatomic, strong) NSString *displayName;

/* 用户名/主叫号码 */
@property(nonatomic, strong) NSString *userName;

/* 用户用来登陆的密码   目前已弃用，用户无法设置
 TODO：由SDK自动与服务器协商，获取密码
 */
@property(nonatomic, strong) NSString *password;

/* 认证名，SDK用来与服务器来认证鉴权   目前已弃用，用户无法设置
 */
@property(nonatomic, strong) NSString *authorizationUserName;

/* 域名，SDK用来与服务器进行认证鉴权 由SDK自动配置 */
@property(nonatomic, strong) NSString *domain;

/* 服务器地址，提供登陆和呼叫服务给SDK的服务器地址 由SDK自动配置 */
@property(nonatomic, strong) NSString *proxyServer;

/* 服务器端口，提供登陆和呼叫服务给SDK的服务器端口 由SDK自动配置 */
@property(nonatomic, assign) unsigned int port;

@end

#pragma mark -- 呼叫状态 --
@interface CallInfo : NSObject {
}

/* 对方的号码 */
@property(nonatomic, strong) NSString *remote;

/* 是否是主动发起呼叫，YES为主动发起呼叫，NO为接收到呼叫 */
@property(nonatomic, readwrite) BOOL isOutgoing;

/* 呼叫状态 */
@property(nonatomic, readwrite) CallStatus callStatus;

/* 呼叫的状态码
 常用的如下：
 100 对方正在处理呼叫
 180 对方振铃
 200 对方接通呼叫
 4xx 客户端发起的请求有问题
 5xx 服务器处理请求出现错误
 603 对方拒绝接听
 */
@property(nonatomic, assign) int sipCode;

@end

#pragma mark -- 注册状态 --
@interface RegInfo : NSObject {
}
/* 登陆状态 */
@property(nonatomic, readwrite) SipRegisterStatus regStatus;

/* 登陆的状态码
 常用的如下：
 401/407  服务器要求鉴权
 200      登陆成功
 403      用户名或者密码错误
 5xx      服务器处理请求出现错误
 */
@property(nonatomic, assign) int sipCode;

@end

#pragma mark -- 回调类 --

@class CallApi;
@protocol CallApiDelegate <NSObject>

/* 通知呼叫状态事件信息 */
- (void)onCallState:(CallInfo *)callInfo;

/* 通知注册状态事件信息 */
- (void)onRegisterState:(RegInfo *)regInfo;

/* 呼叫接通后，通知当前通话的网络状态 */
- (void)onCallStatString:(NSString*)callStat;

@end


#pragma mark --VIOP SDK API --
@interface CallApi : NSObject {
}

/* 初始化SDK */
+ (void)init;

/* 初始化SDK并设置参数
 等价于 init + ApiConfig
 */
+ (void)initWithConfig:(ApiConfig *)config;

/* 设置SDK的参数 */
+ (BOOL)setConfig:(ApiConfig *)config;

/* 设置代理类，用来接收SDK的事件 */
+ (void)setDelegate:(id<CallApiDelegate>)delegate;

/* 发起呼叫 */
+ (BOOL)makeCall:(NSString *)phone;

/* 接听呼叫 */
+ (void)acceptCall;

/* 结束/拒绝 呼叫 */
+ (BOOL)terminateCall;

/* 是否处于通话状态 */
+ (BOOL)isCalling;

/* 发送DTMF 按键音 */
+ (void)sendDTMF:(NSString *)tone;

/* 是否启用扬声器
 YES为启用扬声器
 NO为禁用扬声器
 发起呼叫时SDK自动禁用了扬声器
 */
+ (BOOL)enableSpeaker:(BOOL)enable;

/* 是否获取通话过程中的网络状态并通过代理类回调 */
+ (BOOL)enableCallStat:(BOOL)enable;

/* 是否开启静音
 YES为开启静音
 NO为结束静音
 */
+ (void)setMuted:(BOOL)isMute;

/* 发起登陆 */
+ (BOOL)startRegister;

/* 发起登出 */
+ (BOOL)unRegister;

/* 获取SDK版本号 */
+ (NSString *)getVersion;

/* 获取SDK支持的语音编码，目前是ilbc和pcma */
+ (NSArray *)getSupportedAudioCodec;

/* 获取SDK支持的视频编码 目前不支持视频，该接口返回空 */
+ (NSArray *)getSupportedVideoCodec;

/* 设置SDK目前使用哪些语音编码 */
+ (void)setPreferredAudioCodecs:(NSArray *)auidoCodecs;

/* 设置SDK目前使用哪些视频编码 目前不支持视频，该接口无效 */
+ (void)setPreferredVideoCodecs:(NSArray *)videoCodecs;
@end
