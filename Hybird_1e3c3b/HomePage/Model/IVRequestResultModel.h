//
//  IVRequestResultModel.h
//  Hybird_1e3c3b
//
//  Created by Levy on 12/21/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IVRequestResultModel : NSObject

@property(nonatomic, copy)NSString *message;
@property(nonatomic, assign)BOOL status;
@property(nonatomic, assign)NSInteger code_http;
@property(nonatomic, assign)NSInteger code_system;
@property(nonatomic, strong)id data;

- (instancetype)initWithData:(id)data;


@end

NS_ASSUME_NONNULL_END
