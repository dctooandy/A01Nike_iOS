//
//  BTTForgetPasswordStepThreeController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordStepThreeController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetPasswordStepThreeController (LoadData)

@property (nonatomic, strong) NSMutableArray *mainData;

- (void)loadMainData;

- (void)modifyPasswordWithPwd:(NSString *)pwd account:(NSString *)account accessID:(NSString *)accessID;

@end

NS_ASSUME_NONNULL_END
