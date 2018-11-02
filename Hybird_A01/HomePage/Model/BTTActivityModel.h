//
//  BTTActivityModel.h
//  Hybird_A01
//
//  Created by Domino on 2018/8/20.
//  Copyright © 2018年 Key. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BTTActivityModel : JSONModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, assign) CGFloat descHeight;

@property (nonatomic, assign) CGFloat cellHeight;

@end
