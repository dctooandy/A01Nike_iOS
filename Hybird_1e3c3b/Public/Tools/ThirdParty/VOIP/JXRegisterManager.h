//
//  JXRegisterManager.h
//  44
//
//  Created by tangsonghui on 2018/2/23.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JXRegisterManagerDelegate<NSObject>

- (void)didRegisterResponse:(NSDictionary *)response;

@end
@interface JXRegisterManager : NSObject

#define JXRegisterRest @"http://218.213.95.77:9080/rest/dtezbxlnbnnxeg/daili/users"
//测试环境
//#define JXRegisterRest @"http://223.119.51.211:9080/rest/aza0axd1dmdooq/jx338/users"
@property(nonatomic, weak) id<JXRegisterManagerDelegate> delegate;
+ (instancetype)sharedInstance;

- (BOOL)registerWithUID:(NSString *)uid;
@end
