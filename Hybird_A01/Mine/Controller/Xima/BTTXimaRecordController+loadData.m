//
//  BTTXimaRecordController+loadData.m
//  Hybird_A01
//
//  Created by Domino on 10/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTXimaRecordController+loadData.h"
#import "BTTXimaRecordModel.h"


@implementation BTTXimaRecordController (loadData)

- (void)loadXimaDataIsLastWeek:(BOOL)isLastWeek {
    NSDictionary *params = nil;
    if (isLastWeek) {
        params = @{@"flag":@"last"};
    }
    [self showLoading];
//    TODO:这个地方需要重新处理，暂时先全部注释掉
//    [IVNetwork sendRequestWithSubURL:@"/A01/xm/getWeekDayList" paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
//        [self hideLoading];
//        NSLog(@"%@",response);
//        if (result.status) {
//            BTTXimaRecordModel *model = [BTTXimaRecordModel yy_modelWithDictionary:result.data];
//            self.model = model;
//            [self setupElements];
//        }
//    }];
}

@end
