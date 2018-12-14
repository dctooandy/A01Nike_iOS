//
//  BTTBetInfoModel.m
//  Hybird_A01
//
//  Created by Key on 2018/12/13.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBetInfoModel.h"

@implementation BTTBetInfoModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
- (void)setDifferenceBet:(NSString *)differenceBet
{
    _differenceBet = differenceBet;
    if ([differenceBet doubleValue] > 0.0) {
        NSString *notiyStr = [NSString stringWithFormat:@"请再投注%@即可取款；如已完成投注额，请等待10分钟系统调取投注额数据",differenceBet];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:notiyStr];
        [attrStr setAttributes:@{NSForegroundColorAttributeName : [UIColor yellowColor]} range:NSMakeRange(4, differenceBet.length)];
        self.notiyStr = attrStr.copy;
    }
}
@end
