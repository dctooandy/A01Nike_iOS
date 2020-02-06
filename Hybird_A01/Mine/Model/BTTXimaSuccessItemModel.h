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

@property (nonatomic, copy) NSString *xmAmount;

@property (nonatomic, copy) NSString *errMsg;

@property (nonatomic, copy) NSString *xmRate;

@property (nonatomic, copy) NSString *errCode;

@property (nonatomic, copy) NSString *xmType;

@property (nonatomic, copy) NSString *betAmount;

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *xmTypeName;
@end

NS_ASSUME_NONNULL_END
