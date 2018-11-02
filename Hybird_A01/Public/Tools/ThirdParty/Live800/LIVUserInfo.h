//
//  LIVUserInfo.h
//  LIVDataStorage
//
//  Created by peng zhu on 16/12/1.
//  Copyright © 2016年 peng zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIVUserInfo : NSObject

@property (strong, nonatomic) NSString * userAccount;//用户唯一标识ID，info存在时必须
@property (strong, nonatomic) NSString * loginName; //用户登录名
@property (strong, nonatomic) NSString * name;      //用户姓名
@property (strong, nonatomic) NSString * grade;     //用户等级
@property (strong, nonatomic) NSString * gender;    //用户性别
@property (strong, nonatomic) NSString * mobileNo;  //手机号码
@property (strong, nonatomic) NSString * memo;      //备注信息

@property (strong, nonatomic) NSString * other;     //app定制的信息

@end
