//
//  CNPayCardModel.h
//  HybirdApp
//
//  Created by cean.q on 2018/10/31.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "JSONModel.h"

@protocol CNPayCardModel
@end

@interface CNPayCardModel : JSONModel
@property (nonatomic, copy) NSArray <NSString *> *cardValues;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, readonly, copy) NSString <Ignore> *minCredit;
#pragma mark - 下面是存值
@property (nonatomic, copy) NSString <Ignore> *totalValue;
@property (nonatomic, copy) NSString <Ignore> *chargeValue;
@property (nonatomic, copy) NSString <Ignore> *actualValue;
@property (nonatomic, copy) NSString <Ignore> *cardNo;
@property (nonatomic, copy) NSString <Ignore> *cardPwd;
@property (nonatomic, assign) NSInteger payId;
@property (nonatomic, copy) NSString <Ignore> *amount;
@property (nonatomic, copy) NSString <Ignore> *postUrl;
@end
/**
 {
     cardValues = (
         10,
         20,
         30,
         50,
         100,
         200,
         300,
         500
     );
     code = MOBILE;
     description = "\U203b\U8bf7";
     descriptions = (
        "\U203b\U8bf7\U52a1"
     );
     flag = 1;
     id = 853;
     logo = "";
     name = "\U79fb\U52a8\U5145\U503c\U5361";
     paymentType = yiykcard;
     productid = B01;
     value = 5;
     values = "10,20,30,50,100,200,300,500";
 },
 */
