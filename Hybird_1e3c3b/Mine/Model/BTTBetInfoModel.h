//
//  BTTBetInfoModel.h
//  Hybird_1e3c3b
//
//  Created by Key on 2018/12/13.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "JSONModel.h"

@interface BTTBetInfoModel : JSONModel
@property(nonatomic, copy)NSString *btcRate; //比特币汇率
@property(nonatomic, copy)NSString *depositTotal; //存款
@property(nonatomic, copy)NSString *betTotal; //所需总流水
@property(nonatomic, copy)NSString *currentBet; //当前投注流水
@property(nonatomic, copy)NSString *differenceBet; //还差流水
@property(nonatomic, copy)NSAttributedString *notiyStr;
@property(nonatomic, assign)BOOL status; //是否显示流水信息
@end
