//
//  BTTNoticeModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/8/15.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTNoticeModel;

@interface BTTNoticeMainModel : BTTBaseModel

@property (nonatomic, copy) NSString *totalRow;

@property (nonatomic, copy) NSString *pageSize;

@property (nonatomic, copy) NSString *totalPage;

@property (nonatomic, copy) NSString *pageNo;

@property (nonatomic, strong) NSArray<BTTNoticeModel *> *data;

@end

@interface BTTNoticeModel : BTTBaseModel

@property (nonatomic, copy) NSString *announcement_id;

@property (nonatomic, assign) NSInteger comment_type;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *created_by;

@property (nonatomic, copy) NSString *created_date;

@property (nonatomic, copy) NSString *effectivity_date;

@property (nonatomic, copy) NSString *expiry_date;

@property (nonatomic, copy) NSString *last_update;

@property (nonatomic, copy) NSString *message_title;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *product_id;

@property (nonatomic, copy) NSString *remarks;

@end
