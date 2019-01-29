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
//    [self showLoading];
    dispatch_queue_t queue = dispatch_queue_create("xima.data", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self loadGameshallList:group];
    });
    dispatch_group_notify(group, queue, ^{
        NSString *ximaType = @"";
        for (BTTXimaModel *model in self.xms) {
            if (!ximaType.length) {
                ximaType = model.type;
            } else {
                ximaType = [NSString stringWithFormat:@"%@;%@",ximaType,model.type];
            }
        }
        [self loadXimaCurrentList:ximaType];
        [self loadHistoryData:ximaType];
    });
}

- (void)loadXimaCurrentList:(NSString *)ximaType {
    NSDictionary *params = @{@"xm_type":ximaType};
    [IVNetwork sendRequestWithSubURL:BTTXmCurrentList paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        self.otherListType = BTTXimaOtherListTypeNoData;
        self.currentListType = BTTXimaCurrentListTypeNoData;
        if (result.status) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
                if (result.data[@"other"] && [result.data[@"other"] isKindOfClass:[NSDictionary class]]) {
                    if (result.data[@"other"][@"list"] && [result.data[@"other"][@"list"] isKindOfClass:[NSArray class]]) {
                        BTTXimaTotalModel *model = [BTTXimaTotalModel yy_modelWithDictionary:result.data[@"other"]];
                        self.otherModel = model;
                        self.otherListType = BTTXimaOtherListTypeData;
                    }
                }
                if (result.data[@"valid"] && [result.data[@"valid"] isKindOfClass:[NSDictionary class]]) {
                    if (result.data[@"valid"][@"list"] && [result.data[@"valid"][@"list"] isKindOfClass:[NSArray class]]) {
                        BTTXimaTotalModel *model = [BTTXimaTotalModel yy_modelWithDictionary:result.data[@"valid"]];
                        for (BTTXimaItemModel *itemModel in model.list) {
                            itemModel.isSelect = YES;
                        }
                        self.validModel = model;
                        self.currentListType = BTTXimaCurrentListTypeData;
                    }
                }
            }
        }
        [self setupElements];
    }];
}

- (void)loadGameshallList:(dispatch_group_t)group {
    [BTTHttpManager fetchGamePlatformsWithCompletion:^(IVRequestResultModel *result, id response) {
        if (result.status) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]] && ![result.data isKindOfClass:[NSNull class]]) {
                if (result.data[@"xm"] && [result.data[@"xm"] isKindOfClass:[NSArray class]] && ![result.data[@"xm"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dict in result.data[@"xm"]) {
                        BTTXimaModel *model = [BTTXimaModel yy_modelWithDictionary:dict];
                        [self.xms addObject:model];
                    }
                }
            }
        }
        dispatch_group_leave(group);
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
    }];
}

- (void)loadHistoryData:(NSString *)ximaType {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ximaType forKey:@"xm_type"];
    [params setObject:@(0) forKey:@"delete_flag"];
    [params setObject:@(2) forKey:@"flag"];
    NSString *dateStr = [PublicMethod getLastWeekTime];
    NSString *startStr = [dateStr componentsSeparatedByString:@"||"][0];
    NSString *endStr = [dateStr componentsSeparatedByString:@"||"][1];
    [params setObject:startStr forKey:@"end_date_begin"];
    [params setObject:endStr forKey:@"end_date_end"];
    [params setObject:startStr forKey:@"start_date_begin"];
    [params setObject:endStr forKey:@"start_date_end"];
    [params setObject:@(2000) forKey:@"pageSize"];
    
    [IVNetwork sendRequestWithSubURL:BTTXmHistoryList paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        self.historyListType = BTTXimaHistoryListTypeNoData;
        if (result.status) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
                BTTXimaTotalModel *model = [BTTXimaTotalModel yy_modelWithDictionary:result.data];
                self.histroyModel = model;
                if (model.list.count > 0) {
                    self.historyListType = BTTXimaHistoryListTypeData;
                }
            }
        }
    }];
}


- (void)loadXimaBillOut {
//    [self showLoading];
    NSString *xm_list = @"";
    for (BTTXimaItemModel *itemModel in self.validModel.list) {
        if (xm_list.length) {
            if (itemModel.isSelect) {
                 xm_list = [NSString stringWithFormat:@"%@;%@",xm_list,itemModel.xm_type];
            }
        } else {
            if (itemModel.isSelect) {
                xm_list = itemModel.xm_type;
            }
        }
    }
    if (!xm_list.length) {
        [MBProgressHUD showError:@"请先选择结算的游戏" toView:nil];
        return;
    }
    NSDictionary *params = @{@"xm_list":xm_list};
    [IVNetwork sendRequestWithSubURL:BTTXimaBillOut paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        if (self.xmResults.count) {
            [self.xmResults removeAllObjects];
        }
        if (result.status) {
            if (result.data && [result.data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in result.data) {
                    BTTXimaSuccessItemModel *model = [BTTXimaSuccessItemModel yy_modelWithDictionary:dict];
                    [self.xmResults addObject:model];
                }
                self.ximaStatusType = BTTXimaStatusTypeSuccess;
                BTTXimaHeaderCell *cell = (BTTXimaHeaderCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell setBtnOneType:BTTXimaHeaderBtnOneTypeOtherNormal];
                [self setupElements];
            }
            
        }
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
        
    }];
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
