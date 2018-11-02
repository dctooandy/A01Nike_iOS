//
//  UDPSocket.h
//  UDPSocketDemo
//
//  Created by Robert on 11/03/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 心跳包管理 */
@interface HDSocketManager : NSObject
@property(nonatomic, copy)NSString *configIp;
@property(nonatomic, copy)NSString *configPort;
+ (instancetype)shareInstance;


- (void)setDeviceToken:(NSData *)deviceTokenData;

//建立长链接
- (void)startConnect;
//断开长链接
- (void)dismissConnect;

@end
