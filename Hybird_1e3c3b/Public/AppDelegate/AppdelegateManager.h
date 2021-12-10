//
//  AppdelegateManager.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/12/2.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppdelegateManager : NSObject
/**
所有网关列表
 */
@property (nonatomic, copy, nullable) NSArray *gateways;
/**
所有网关列表
 */
@property (nonatomic, copy, nullable) NSArray *websides;
+ (instancetype)shareManager ;
@end

NS_ASSUME_NONNULL_END
