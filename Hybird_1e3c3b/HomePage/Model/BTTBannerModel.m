//
//  BTTBannerModel.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/8/15.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTBannerModel.h"

@implementation BTTBannerModel

- (NSString *)imgurl {
    if (![_imgurl hasPrefix:@"http"]) {
        _imgurl = [PublicMethod nowCDNWithUrl:_imgurl];
    }
    return _imgurl;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"action":[BTTBannerActionModel class]};
}

@end

@implementation BTTBannerActionModel



- (NSString *)detail {
    if (_detail.length && ![_detail hasPrefix:@"http"]&&![_detail containsString:@"gameId"]) {
        NSString * str = [_detail substringWithRange:NSMakeRange(0,1)];
        if ([str isEqualToString:@"/"]) {
            _detail = [_detail substringWithRange:NSMakeRange(str.length,_detail.length-str.length)];
        }
        _detail = [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],_detail];
    }
    return _detail;
}

@end
