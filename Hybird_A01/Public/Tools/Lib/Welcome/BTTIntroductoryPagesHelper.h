//
//  BTTIntroductoryPagesHelper.h
//  Hybird_A01
//
//  Created by domino on 2018/10/01.
//  Copyright © 2018年 domino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTIntroductoryPagesHelper : NSObject

+ (instancetype)shareInstance;

+ (void)showIntroductoryPageView:(NSArray<NSString *> *)imageArray;

@end
