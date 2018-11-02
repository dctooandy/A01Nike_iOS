//
//  UDPSocket.m
//  UDPSocketDemo
//
//  Created by Robert on 11/03/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import "HDSocketManager.h"
#import <GCDAsyncUdpSocket.h>
#include <netdb.h>
#include <arpa/inet.h>
#import "NSString+Expand.h"
#import "HAInitConfig.h"
#import "AppInitializeConfig.h"
@interface HDSocketManager()<GCDAsyncUdpSocketDelegate>

@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;

// 心跳包的第一个字段为标志位(1字节)，定义二进制字符串，简单点，最后转成十进制， 其中标志位的1个字节，前三位的位数，第一位为1固定值，第二位，如果为0，新的请求，如果为1带上了服务器返回的UUID 如果服务器返回数据中的这个位数是1代表是uuid的包,第三位0代表未打开客户端，1代表打开客户端，IOS永远为1
@property (strong, nonatomic) NSString *flag;

// 心跳包的第二个字段为包长，也定义二进制字符串，最后转成十进制(1字节)
@property (strong, nonatomic) NSString *length;

// 心跳包的第三个字段为包序(1字节)，IOS传1
@property (strong, nonatomic) NSString *order;

// 心跳包的第四个字段，如果没有uuid的话，第四个字段传平台参数(1字节)，IOS传2，如果有uuid的话，不传这个参数，传16字节的uuid
@property (strong, nonatomic) NSString *platform;

// 心跳包的第四个字段 服务器返回的uuid (16字节)
@property (strong, nonatomic) NSData *uuid;

// 心跳包的第五个字段 anns token (32字节)
@property (strong, nonatomic) NSData *apnsToken;

// 心跳包的第六个字段 用户id (4字节)
//@property (assign, nonatomic) int userid;

/**
 心跳包的第七个字段 产品id 标志每个产品的唯一标志 如果有uuid的话，该产品id将不传
 */
@property (strong, nonatomic) NSString *productId;

// 定时器
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSString *ip;

@property (assign, nonatomic) NSInteger port;
@end

@implementation HDSocketManager

#pragma mark 公共方法
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static HDSocketManager *shareInstance = nil;
    dispatch_once(&onceToken, ^{
        shareInstance = [[super allocWithZone:NULL] init] ;
    }) ;
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _flag = @"10100000";
        _length = @"00000001";
        _order = @"00000001";
        _platform = @"00000010";
        //self.userid = 0;
        self.productId = [HAInitConfig productId];
        self.uuid = nil;
    }
    return self;
}

- (void)setDeviceToken:(NSData *)deviceTokenData {
    self.apnsToken = deviceTokenData;
}

/** 建立连接 */
- (void)startConnect {
    switch (EnvirmentType) {
        case 0:
        {
            _ip = _configIp ? _configIp : @"10.71.12.105";
            _port = _configPort ? [_configPort integerValue] : 8090;
        }
            break;
        case 1:
        {
            _ip = _configIp ? _configIp : @"115.84.241.212";
            _port = _configPort ? [_configPort integerValue] : 8090;
        }
            break;
        case 2:
        {
            _ip = _configIp ? _configIp : @"202.83.195.101";
            _port = _configPort ? [_configPort integerValue] : 28721;
        }
            break;
        default:
            break;
    }
    
    [self dismissConnect];
    
    if (self.apnsToken == nil) return;
    
    [self timerSendData];
    [self startTimer];
}

/** 停止发包 */
- (void)dismissConnect {
    [self releaseTimer];
}

/** 用户ID */
- (int)userid {
    NSNumber *userid = [NSNumber numberWithInteger:[IVNetwork userInfo].customerId];
    return userid.intValue;
}

- (void)startTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerSendData) userInfo:nil repeats:YES];
    }
}

- (void)releaseTimer {
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    _udpSocket = nil;
}

- (void)timerSendData {
    [self.udpSocket sendData:[self spellHeatPacket] toHost:self.ip port:self.port withTimeout:-1 tag:0];
    NSError *error;
    [self.udpSocket beginReceiving:&error];
}

- (NSData *)spellHeatPacket {
    
    if (self.uuid) {
        self.flag = @"11100000";
    }
    else{
        self.flag = @"10100000";
    }
    
    Byte  flagByte = [self toDecimalByteWithBinarySystem:_flag];
    Byte  lengthByte = [self toDecimalByteWithBinarySystem:_length];
    Byte  orderByte = [self toDecimalByteWithBinarySystem:_order];
    Byte  platformByte = [self toDecimalByteWithBinarySystem:_platform];
    
    NSMutableData *sendData = [[NSMutableData alloc] init];
    // 追加标志位数据
    [sendData appendBytes:&flagByte length:1];
    // 追加长度数据
    [sendData appendBytes:&lengthByte length:1];
    // 追加包序数据
    [sendData appendBytes:&orderByte length:1];
    if (!self.uuid){
        // 如果没有uuid追加平台数据
        [sendData appendBytes:&platformByte length:1];
    }
    else{
        // 如果有uuid追加uuid数据
        [sendData appendData:self.uuid];
    }
    // 追加apnsToken数据
    [sendData appendData:self.apnsToken];
    
    // 追加用户id数据
    int userid = self.userid;
    NSData *userData = [NSData dataWithBytes:&userid length: sizeof(userid)];
    [sendData appendData:userData];
   
    // 如果没有uuid的话，一定要带上产品id 如果有uuid的话，就不传产品id
    if (!self.uuid && ![NSString isBlankString:self.productId]) {
        NSData *data = [self.productId dataUsingEncoding:NSUTF8StringEncoding];
        [sendData appendData:data];
    }
    
    // 取掉前三位的标志位字节，剩余的是数据长度
    int len = (int)sendData.length - 3;
    lengthByte = (Byte)(0XFF & len);
    
    // 替换包长字节的数据
    [sendData replaceBytesInRange:NSMakeRange(1, 1) withBytes:&lengthByte length:1];
    return sendData;
}

/**
 处理收到的socket包

 @param data 包数据
 */
- (void)handleReciveSocketPacket:(NSData *)data {
    Byte *byte = (Byte *)[data bytes];
    // 取出byte数组的第1个字节，是标志位,然后再取出标志位字节的位数放到一个数组中
    Byte flagByte = byte[0];
    Byte flagBits [8] = {0};
    for (int i = 7; i >= 0; i -- ) {
        flagBits[i] = (Byte)(flagByte & 1);
        flagByte = (Byte) (flagByte >> 1);
    }
    // 取出标志位字节的第二位用来判断是否是带uuid的包
    Byte *bit = &flagBits[1];
    // 把标志位字节的第二位转成整型
    int bitValue = [self byteToInt:bit];
    if (bitValue == 1) {
        [self handleUUIDPacket:data];
    }
    else{
        [self handleOtherPacket:data];
    }
}

/**
 处理UUID包 下次发包的时候带上,如果uuid包是全0的话，是错误的uuid包,这个时候把uuid字段置为nil重新请求uuid包，如果不是uuid包的话，就是心跳包，不用处理,

 @param data 包数据
 */
- (void)handleUUIDPacket:(NSData *)data {
    Byte *byte = (Byte *)[data bytes];
    Byte *uuid = malloc(16);
    // 从第四个字节开始取uuid，因为uuid是第四个字节开始的
    if (data.length == 19) {
        memcpy(uuid, &byte[3], 16);
        self.uuid = [self byteToString:uuid length:16];
        NSLog(@"接收到uuid包:%@", self.uuid);
        // 判断uuid是不是全0，如果是全0的话，就是错误的uuid要重新请求uuid
        int value = 1;
        for (int i = 0; i < self.uuid.length / 4; i ++) {
            int k = 1;
            [self.uuid getBytes: &k range:NSMakeRange(i * 4, sizeof(k))];
            value = k;
            if (k != 0) {
                break;
            }
        }
        if (value == 0) {
            NSLog(@"错误的uuid");
            self.uuid = nil;
        }
    }
    free(uuid);
}

/**
 处理其它包 预留

 @param data 包数据
 */
- (void)handleOtherPacket:(NSData *)data {
    NSLog(@"接收到心跳包:%@",data);
}

- (GCDAsyncUdpSocket *)udpSocket {
    if (!_udpSocket) {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _udpSocket;
}

#pragma mark GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    NSLog(@"didConnectToAddress");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error {
    NSLog(@"didNotConnect");
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"didSendDataWithTag");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error {
    NSLog(@"didSendDataWithTag");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext {
    NSLog(@"didReceiveData");
    [self handleReciveSocketPacket:data];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error {
    NSLog(@"udpSocketDidClose");
}

#pragma mark 类型转换
/**
 二进制字符串转十进制字符串
 
 @param binary 二进制字符串
 @return 十进制整型
 */
- (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary {
    int decimal = 0;
    int tempDecimal = 0;
    for (int i = 0; i < binary.length; i ++ ) {
        tempDecimal = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        tempDecimal  = tempDecimal * powf(2, binary.length - i -1);
        decimal += tempDecimal;
    }
    NSString *result = [NSString stringWithFormat:@"%d",tempDecimal];
    return result;
}


/**
 二进制字符串转十进制Byte

 @param binary 二进制字符串
 @return 十进制的Byte
 */
- (Byte)toDecimalByteWithBinarySystem:(NSString *)binary {
    int decimal = 0;
    int tempDecimal = 0;
    for (int i = 0; i < binary.length; i ++ ) {
        tempDecimal = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        tempDecimal  = tempDecimal * powf(2, binary.length - i -1);
        decimal += tempDecimal;
    }
    Byte  byte = (Byte)(0XFF & decimal);
    return byte;
}

/**
 byte转NSSData

 @param byte byte
 @param length 长度
 @return NSData
 */
- (NSData *)byteToString:(Byte *)byte length:(int)length {
    NSData *data = [[NSData alloc] initWithBytes:byte length:length];
    return data;
}

- (int)byteToInt:(Byte[]) byte {
    int height = 0;
    NSData * testData =[NSData dataWithBytes:byte length:4];
    for (int i = 0; i < [testData length]; i++){
        if (byte[[testData length]-i] >= 0){
            height = height + byte[[testData length]-i];
        }
        else{
            height = height + 256 + byte[[testData length]-i];
        }
        height = height * 256;
    }
    if (byte[0] >= 0){
        height = height + byte[0];
    }
    else {
        height = height + 256 + byte[0];
    }
    return height;
}


- (NSString *)getIPWithHostName:(const NSString *)hostName {
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    @try {
        phot = gethostbyname(hostN);

    }
    @catch (NSException *exception) {
        return nil;
    }
    struct in_addr ip_addr;
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));

    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}
@end
