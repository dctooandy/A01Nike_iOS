//
//  BTTBannerModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/8/15.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTBaseModel.h"


@class BTTBannerActionModel;

@interface BTTBannerModel : BTTBaseModel

@property (nonatomic, copy) NSString *begin_time;

@property (nonatomic, copy) NSString *bgcolor;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *intro;

@property (nonatomic, copy) NSString *t_imgurl;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) BTTBannerActionModel *action;

@end

@interface BTTBannerActionModel : BTTBaseModel

@property (nonatomic, copy) NSString *detail; ///< 图片链接网页

@property (nonatomic, copy) NSString *type;

@end
