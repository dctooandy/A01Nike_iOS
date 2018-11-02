//
//  BTTRedDotManager.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/4.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTRedDotManager.h"

@implementation BTTRedDotManager

+ (NSArray *)registerProfiles {
    return @[@{BTTHomePage:@{BTTHomePageItemsKey:@[BTTHomePageMessage]}},@{BTTMineCenter:@{BTTMineCenterItemsKey:@[BTTMineCenterMessage,BTTMineCenterVersion]}}];
}

@end
