//
//  BTTXimaController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaController+LoadData.h"
#import "BTTXimaModel.h"
#import "BTTXimaItemModel.h"
#import "BTTXimaSuccessItemModel.h"
#import "BTTXimaHeaderCell.h"

@implementation BTTXimaController (LoadData)

- (void)loadMainData {
    NSDictionary *params = @{
        @"loginName":[IVNetwork savedUserInfo].loginName
    };
    [IVNetwork requestPostWithUrl:BTTXimaAmount paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        self.otherListType = BTTXimaOtherListTypeNoData;
        self.currentListType = BTTXimaCurrentListTypeNoData;
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTXimaTotalModel *model = [BTTXimaTotalModel yy_modelWithJSON:result.body];
            self.otherModel = model;
            self.validModel = model;
            self.currentListType = BTTXimaCurrentListTypeData;
            self.otherListType = BTTXimaOtherListTypeData;
            [self setupElements];
        }
    }];
    [self loadHistoryData];
}



- (void)loadHistoryData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
    NSString *dateStr = [PublicMethod getLastWeekTime];
    NSString *startStr = [dateStr componentsSeparatedByString:@"||"][0];
    NSString *endStr = [dateStr componentsSeparatedByString:@"||"][1];
    [params setValue:startStr forKey:@"beginDate"];
    [params setValue:endStr forKey:@"endDate"];
    [params setValue:@[@0,@2] forKey:@"flags"];
    [params setValue:@1 forKey:@"inclSumAmount"];
    [params setValue:@1 forKey:@"pageNo"];
    [params setValue:@100 forKey:@"pageSize"];
    [params setValue:@1 forKey:@"inclDeleted"];
    
    [IVNetwork requestPostWithUrl:BTTXimaQueryRequest paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        self.historyListType = BTTXimaHistoryListTypeNoData;
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if ([result.body isKindOfClass:[NSDictionary class]]) {
                self.historyArray = result.body[@"data"];
                if (self.historyArray.count>0) {
                    self.historyListType = BTTXimaHistoryListTypeData;
                }
            }
        }
    }];
}


- (void)loadXimaBillOut {
//    [self showLoading];
//    NSString *xm_list = @"";
//    for (BTTXimaItemModel *itemModel in self.validModel.xmList) {
//        if (xm_list.length) {
//            if (itemModel.isSelect) {
//                 xm_list = [NSString stringWithFormat:@"%@;%@",xm_list,itemModel.xm_type];
//            }
//        } else {
//            if (itemModel.isSelect) {
//                xm_list = itemModel.xm_type;
//            }
//        }
//    }
//    if (!xm_list.length) {
//        [MBProgressHUD showError:@"请先选择结算的游戏" toView:nil];
//        return;
//    }
//    NSDictionary *params = @{@"xm_list":xm_list};
//    NSMutableArray *xmResults = [NSMutableArray array];
    //TODO:
//    [IVNetwork sendRequestWithSubURL:BTTXimaBillOut paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
//        NSLog(@"%@",response);
//        [self hideLoading];
//        if (self.xmResults.count) {
//            [self.xmResults removeAllObjects];
//        }
//        if (result.status) {
//            if (result.data && [result.data isKindOfClass:[NSArray class]]) {
//                for (NSDictionary *dict in result.data) {
//                    BTTXimaSuccessItemModel *model = [BTTXimaSuccessItemModel yy_modelWithDictionary:dict];
//                    [xmResults addObject:model];
//                }
//                self.xmResults = xmResults.mutableCopy;
//                self.ximaStatusType = BTTXimaStatusTypeSuccess;
//                BTTXimaHeaderCell *cell = (BTTXimaHeaderCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//                [cell setBtnOneType:BTTXimaHeaderBtnOneTypeOtherNormal];
//                [self setupElements];
//            }
//
//        }
//        if (result.message.length) {
//            [MBProgressHUD showError:result.message toView:nil];
//        }
//
//    }];
}


- (NSMutableArray *)xms {
    NSMutableArray *xms = objc_getAssociatedObject(self, _cmd);
    if (!xms) {
        xms = [NSMutableArray array];
        [self setXms:xms];
    }
    return xms;
}

- (void)setXms:(NSMutableArray *)xms {
    objc_setAssociatedObject(self, @selector(xms), xms, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)xmResults {
    NSMutableArray *xmResults = objc_getAssociatedObject(self, _cmd);
    if (!xmResults) {
        xmResults = [NSMutableArray array];
        [self setXmResults:xmResults];
    }
    return xmResults;
}

- (void)setXmResults:(NSMutableArray *)xmResults {
    objc_setAssociatedObject(self, @selector(xmResults), xmResults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
