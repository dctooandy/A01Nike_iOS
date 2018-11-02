//
//  BTTBannerModel.h
//  Hybird_A01
//
//  Created by Domino on 2018/8/15.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTBaseModel.h"

@interface BTTBannerModel : BTTBaseModel

@property (nonatomic, strong) NSDictionary *index;

@end

@interface BTTBannerImageModel : NSObject

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *detail; ///< 图片链接网页

@end
