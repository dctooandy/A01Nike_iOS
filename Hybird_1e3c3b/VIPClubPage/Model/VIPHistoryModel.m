//
//  VIPHistoryModel.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/9/6.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "VIPHistoryModel.h"

@implementation VIPHistoryModel
- (instancetype)initWithSideBarData:(NSMutableArray<VIPHistorySideBarModel *> *)sideBarData withImageModel:(NSMutableArray<VIPHistoryImageModel *> *)imageData
{
    self = [super init];
    _sideBarData = sideBarData;
    _imageData = imageData;
    return  self;
}
@end
@implementation VIPHistorySideBarModel
- (instancetype)initWithYearString:(NSString * )yearString withImageName:(NSString*)imageName withIsSelected:(BOOL)isSelected withIsFirstData:(BOOL)isFirstData
{
    self = [super init];
    _yearString = yearString;
    _imageName = imageName;
    _isSelected = isSelected;
    _isFirstData = isFirstData;
    return  self;
}
@end

@implementation VIPHistoryImageModel
- (instancetype)initWithYearString:(NSString* )yearString
                   WithMonthString:(NSString* )monthString
                     withImageName:(NSString* )imageName
                           withUrl:(NSString* )url
                withTopTitleString:(NSString* )topTitleString
                withSubTitleString:(NSString* )subTitleString
                   withIsFirstData:(BOOL )isFirstData
                     withIsDetails:(BOOL )details
{
    self = [super init];
    _yearString = yearString;
    _monthString = monthString;
    _imageName = imageName;
    _url = url;
    _topTitleString = topTitleString;
    _subTitleString = subTitleString;
    _isFirstData = isFirstData;
    _details = details;
    return  self;
}
- (NSString *)imageURLString {
    if (![_imageName hasPrefix:@"http"]) {
        return [PublicMethod nowCDNWithUrl:_imageName];
    }
    return _imageName;
}
@end
