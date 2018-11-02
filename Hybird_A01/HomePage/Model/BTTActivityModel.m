//
//  BTTActivityModel.m
//  Hybird_A01
//
//  Created by Domino on 2018/8/20.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BTTActivityModel.h"

@implementation BTTActivityModel

- (CGFloat)descHeight {
    if (!_descHeight) {
        UIFont *font = [UIFont systemFontOfSize:12];
        CGRect suggestedRect = [self.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font}
                                                  context:nil];
        _descHeight += suggestedRect.size.height;
    }
    return _descHeight;
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
    _cellHeight += (imageHeight + 52);
    return _cellHeight;
}

@end
