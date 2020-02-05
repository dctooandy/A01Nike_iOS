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
    self.selectedArray = [NSMutableArray new];
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
            BTTXimaTotalModel *otherModel = [BTTXimaTotalModel yy_modelWithJSON:result.body];
            NSMutableArray *list = [[NSMutableArray alloc]init];
            NSMutableArray *otherList = [[NSMutableArray alloc]init];
            for (int i=0; i<model.xmList.count; i++) {
                if (model.xmList[i].betAmount!=0) {
                    [self.selectedArray addObject:model.xmList[i]];
                    [list addObject:model.xmList[i]];
                }else{
                    [otherList addObject:model.xmList[i]];
                }
                if (i==model.xmList.count-1) {
                    model.xmList = list;
                    otherModel.xmList = otherList;
                    self.otherModel = otherModel;
                    self.validModel = model;
                    if (list.count>0) {
                        self.currentListType = BTTXimaCurrentListTypeData;
                    }
                    if (otherList.count>0) {
                        self.otherListType = BTTXimaOtherListTypeData;
                    }
                    [self setupElements];
                }
            }
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
    [self showLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"isXm"] = @0;
    params[@"xmBeginDate"] = @"2020-01-27 00:00:00";
    params[@"xmEndDate"] = @"2020-01-02 23:59:59";
    
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    NSMutableArray *array = [NSMutableArray new];
    for (BTTXimaItemModel *itemModel in self.selectedArray) {
        NSDictionary *json = [itemModel yy_modelToJSONObject];
        [array addObject:json];
    }
    params[@"xmRequest"] = array;
    [IVNetwork requestPostWithUrl:BTTXiMaRequest paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];

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
