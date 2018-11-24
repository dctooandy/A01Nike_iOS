//
//  BTTXimaSuccessItemModel.h
//  Hybird_A01
//
//  Created by Domino on 24/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTXimaSuccessItemModel : BTTBaseModel

//amount = "7.81";
//err = "";
//name = "AG\U65d7\U8230\U5385";
//status = 1;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *err;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
