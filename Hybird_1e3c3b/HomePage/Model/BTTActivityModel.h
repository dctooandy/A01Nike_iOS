//
//  BTTActivityModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/8/20.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTActivityImageModel;

@interface BTTActivityModel : BTTBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSArray<BTTActivityImageModel *> *imgs;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat descHeight;

@property (nonatomic, strong) NSArray *imgTitles;

@end

@interface BTTActivityImageModel : BTTBaseModel

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *imgDesc;

@end
