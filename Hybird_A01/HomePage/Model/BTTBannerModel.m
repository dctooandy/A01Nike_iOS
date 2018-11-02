//
//  BTTBannerModel.m
//  Hybird_A01
//
//  Created by Domino on 2018/8/15.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTBannerModel.h"

@implementation BTTBannerModel


@end

@implementation BTTBannerImageModel

- (NSString *)imgurl {
    if (![_imgurl hasPrefix:@"http"]) {
        _imgurl = [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],_imgurl];
    }
    return _imgurl;
}

- (NSString *)detail {
    if (_detail.length && ![_detail hasPrefix:@"http"]) {
        _detail = [NSString stringWithFormat:@"%@/%@",[IVNetwork h5Domain],_detail];
    }
    return _detail;
}

@end
