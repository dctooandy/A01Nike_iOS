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

@implementation BTTXimaController (LoadData)

- (void)loadMainData {
    [self showLoading];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self loadGameshallList:group];
    });
    dispatch_group_notify(group, queue, ^{
        NSString *ximaType = @"";
        for (BTTXimaModel *model in self.xms) {
            if (ximaType.length) {
                ximaType = model.type;
            } else {
                ximaType = [NSString stringWithFormat:@"%@;%@",ximaType,model.type];
            }
        }
        [self loadXimaCurrentList:ximaType group:group];
    });
}

- (void)loadXimaCurrentList:(NSString *)ximaType group:(dispatch_group_t)group {
    NSDictionary *params = @{@"xm_type":ximaType};
    [IVNetwork sendRequestWithSubURL:BTTXmCurrentList paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        if (result.code_http == 200) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
                if (result.data[@"other"] && [result.data[@"other"] isKindOfClass:[NSDictionary class]]) {
                    if (result.data[@"other"][@"list"] && [result.data[@"other"][@"list"] isKindOfClass:[NSArray class]]) {
                        BTTXimaTotalModel *model = [BTTXimaTotalModel yy_modelWithDictionary:result.data[@"other"]];
                        self.otherModel = model;
                    }
                }
                if (result.data[@"valid"] && [result.data[@"valid"] isKindOfClass:[NSDictionary class]]) {
                    if (result.data[@"valid"][@"list"] && [result.data[@"valid"][@"list"] isKindOfClass:[NSArray class]]) {
                        BTTXimaTotalModel *model = [BTTXimaTotalModel yy_modelWithDictionary:result.data[@"valid"]];
                        self.validModel = model;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }];
}

- (void)loadGameshallList:(dispatch_group_t)group {
    [IVNetwork sendRequestWithSubURL:BTTGamePlatforms paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
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
    NSString *endTime = [PublicMethod timeIntervalSince1970];
    [IVNetwork sendRequestWithSubURL:BTTXmHistoryList paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        
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

- (NSMutableArray *)historys {
    NSMutableArray *historys = objc_getAssociatedObject(self, _cmd);
    if (!historys) {
        historys = [NSMutableArray array];
        [self setHistorys:historys];
    }
    return historys;
}

- (void)setHistorys:(NSMutableArray *)historys {
    objc_setAssociatedObject(self, @selector(historys), historys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
