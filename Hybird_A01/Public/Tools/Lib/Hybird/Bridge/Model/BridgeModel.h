//
//  BusinessModel.h
//  MainHybird
//
//  Created by Key on 2018/6/7.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "JSONModel.h"

@interface BridgeModel : JSONModel
@property (nonatomic, copy) NSString      *requestId;
@property (nonatomic, copy) NSString      *service;
@property (nonatomic, copy) NSString      *method;
@property (nonatomic, copy) NSDictionary  *data;
@end
