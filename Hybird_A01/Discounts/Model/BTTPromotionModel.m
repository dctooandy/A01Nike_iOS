//
//  BTTPromotionModel.m
//  Hybird_A01
//
//  Created by Domino on 17/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPromotionModel.h"

@implementation BTTPromotionModel

- (NSString *)href {
    if (![_href hasPrefix:@"http"] && ([_href containsString:@"htm"]||[_href containsString:@"#/activity_pages"])) {
        return [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain], _href];
    }
    return _href;
}

- (NSString *)imgurl {
    if (![_imgurl hasPrefix:@"http"]) {
        
        return [PublicMethod nowCDNWithUrl:_imgurl];
    }
    return _imgurl;
}



@end
