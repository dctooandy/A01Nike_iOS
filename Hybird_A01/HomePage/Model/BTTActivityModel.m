//
//  BTTActivityModel.m
//  Hybird_A01
//
//  Created by Domino on 2018/8/20.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTActivityModel.h"

@implementation BTTActivityModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imgs":[BTTActivityImageModel class]};
}

- (CGFloat)cellHeight {
    _cellHeight = 0;
    CGFloat imageHeight = 0;
    if (SCREEN_WIDTH == 320) {
        imageHeight = 180;
    } else if (SCREEN_WIDTH == 375) {
        imageHeight = 200;
    } else if (SCREEN_WIDTH == 414 || KIsiPhoneX) {
        imageHeight = 220;
    }
    _cellHeight += (imageHeight + 52 + self.descHeight);
    return _cellHeight;
}

- (CGFloat)descHeight {
    return [PublicMethod getFontsHeightWithString:self.desc].height;
}

- (NSArray *)imageUrls {
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (BTTActivityImageModel *model in _imgs) {
        [imageUrls addObject:model.img];
    }
    _imageUrls = imageUrls;
    return _imageUrls;
}

- (NSArray *)imgTitles {
    NSMutableArray *titles = [NSMutableArray array];
    for (BTTActivityImageModel *model in _imgs) {
        [titles addObject:model.imgDesc];
    }
    _imgTitles = titles;
    return _imgTitles;
}

@end

@implementation BTTActivityImageModel

- (NSString *)img {
    if (![_img hasPrefix:@"http"]) {
        return [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],_img];
    }
    return _img;
}

@end
