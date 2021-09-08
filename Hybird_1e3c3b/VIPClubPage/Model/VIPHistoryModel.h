//
//  VIPHistoryModel.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/9/6.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class VIPHistorySideBarModel;
@class VIPHistoryImageModel;
NS_ASSUME_NONNULL_BEGIN
@interface VIPHistoryModel : BTTBaseModel

@property (nonatomic, strong) NSMutableArray<VIPHistorySideBarModel *> *sideBarData;
@property (nonatomic, strong) NSMutableArray<VIPHistoryImageModel *> *imageData;
- (instancetype)initWithSideBarData:(NSMutableArray<VIPHistorySideBarModel *> *)sideBarData withImageModel:(NSMutableArray<VIPHistoryImageModel *> *)imageData;
@end

@interface VIPHistorySideBarModel : BTTBaseModel
@property (nonatomic, strong) NSString *yearString;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isFirstData;
- (instancetype)initWithYearString:(NSString * )yearString withImageName:(NSString*)imageName withIsSelected:(BOOL)isSelected withIsFirstData:(BOOL)isFirstData;
@end

@interface VIPHistoryImageModel : BTTBaseModel
@property (nonatomic, strong) NSString *yearString;
@property (nonatomic, strong) NSString *monthString;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *topTitleString;
@property (nonatomic, strong) NSString *subTitleString;
@property (nonatomic, assign) BOOL isFirstData;
- (instancetype)initWithYearString:(NSString* )yearString
                   WithMonthString:(NSString* )monthString
                     withImageName:(NSString* )imageName
                           withUrl:(NSString* )url
                withTopTitleString:(NSString* )topTitleString
                withSubTitleString:(NSString* )subTitleString
                   withIsFirstData:(BOOL )isFirstData;
@end
NS_ASSUME_NONNULL_END




